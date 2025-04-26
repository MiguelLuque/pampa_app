import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pampa_app/core/error/app_error_handler.dart';
import 'package:pampa_app/features/auth/domain/models/user.dart';
import 'package:pampa_app/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] using Firebase Authentication
class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Creates a new [FirebaseAuthRepository] instance
  ///
  /// [firebaseAuth] - The [firebase_auth.FirebaseAuth] instance
  FirebaseAuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  /// Converts a Firebase User to our custom User model
  User _mapFirebaseUser(firebase_auth.User firebaseUser) {
    try {
      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      return _mapFirebaseUser(firebaseUser);
    } catch (e) {
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Primero intentamos obtener el usuario actual
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await _firebaseAuth.signOut();
      }

      // Luego intentamos el inicio de sesión
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verificamos que tengamos un usuario válido
      if (userCredential.user == null) {
        throw AppError(
          type: ErrorType.authentication,
          message:
              'No se pudo obtener la información del usuario después del inicio de sesión',
          stackTrace: StackTrace.current,
        );
      }

      // Esperamos un momento para asegurarnos de que la información se haya actualizado
      await Future.delayed(const Duration(milliseconds: 500));

      // Recargamos la información del usuario
      await userCredential.user?.reload();

      // Obtenemos el usuario actualizado
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw AppError(
          type: ErrorType.authentication,
          message: 'No se pudo obtener el usuario actualizado',
          stackTrace: StackTrace.current,
        );
      }

      return _mapFirebaseUser(updatedUser);
    } catch (e) {
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw AppError(
          type: ErrorType.authentication,
          message: 'No se pudo crear el usuario',
          stackTrace: StackTrace.current,
        );
      }

      // Update display name if provided
      if (displayName != null) {
        await user.updateDisplayName(displayName);
        // Reload user to get updated info
        await user.reload();
      }
      User newUser = _mapFirebaseUser(_firebaseAuth.currentUser!);
      await _createUser(newUser);

      return newUser;
    } catch (e) {
      //quiero lanzar una exception de autenticación
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
    } catch (_) {
      // Ignorar si no había inicio de sesión de Google
    }
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<User> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AppError(
        type: ErrorType.authentication,
        stackTrace: StackTrace.current,
      );
    }

    try {
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Reload user to get updated info
      await user.reload();
      return _mapFirebaseUser(_firebaseAuth.currentUser!);
    } catch (e) {
      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw AppError(
          type: ErrorType.authentication,
          message: 'Inicio de Google cancelado por el usuario',
          stackTrace: StackTrace.current,
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user == null) {
        throw AppError(
          type: ErrorType.authentication,
          message: 'No se obtuvo usuario tras Google Sign-In',
          stackTrace: StackTrace.current,
        );
      }

      await userCred.user!.reload();
      User user = _mapFirebaseUser(_firebaseAuth.currentUser!);

      if (userCred.additionalUserInfo?.isNewUser ?? false) {
        await _createUser(user);
      }

      return user;
    } catch (e) {
      //si es app error, lo lanzamos, si no, lo convertimos a app error pero si exception es null es porque el usuario ha cancelado el inicio de sesion con google

      throw AppError(
        type: ErrorType.authentication,
        exception: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> _createUser(User user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .set(user.toJson());
  }
}
