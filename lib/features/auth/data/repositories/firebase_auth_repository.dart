import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
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
      throw Exception('Error al mapear el usuario de Firebase: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      return _mapFirebaseUser(firebaseUser);
    } catch (e) {
      throw Exception('Error al obtener el usuario actual: $e');
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
        throw Exception(
          'No se pudo obtener la información del usuario después del inicio de sesión',
        );
      }

      // Esperamos un momento para asegurarnos de que la información se haya actualizado
      await Future.delayed(const Duration(milliseconds: 500));

      // Recargamos la información del usuario
      await userCredential.user?.reload();

      // Obtenemos el usuario actualizado
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception('No se pudo obtener el usuario actualizado');
      }

      return _mapFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado durante el inicio de sesión: $e');
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
        throw Exception('User not created');
      }

      // Update display name if provided
      if (displayName != null) {
        await user.updateDisplayName(displayName);
        // Reload user to get updated info
        await user.reload();
      }

      return _mapFirebaseUser(_firebaseAuth.currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<User> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
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
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  /// Handle Firebase Authentication exceptions and map them to user-friendly exceptions
  Exception _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return Exception(
          'No se encontró ningún usuario con este correo electrónico',
        );
      case 'wrong-password':
        return Exception('Contraseña incorrecta');
      case 'email-already-in-use':
        return Exception('Este correo electrónico ya está en uso');
      case 'invalid-email':
        return Exception('El correo electrónico no es válido');
      case 'weak-password':
        return Exception('La contraseña es demasiado débil');
      case 'operation-not-allowed':
        return Exception('Operación no permitida');
      case 'user-disabled':
        return Exception('Este usuario ha sido deshabilitado');
      case 'too-many-requests':
        return Exception('Demasiados intentos fallidos. Inténtalo más tarde');
      case 'network-request-failed':
        return Exception('Error de conexión. Verifica tu conexión a internet');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Inicio de Google cancelado por el usuario');
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user == null) {
        throw Exception('No se obtuvo usuario tras Google Sign-In');
      }
      await userCred.user!.reload();
      return _mapFirebaseUser(_firebaseAuth.currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado en Google Sign-In: $e');
    }
  }
}
