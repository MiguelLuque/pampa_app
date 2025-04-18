import 'package:pampa_app/features/auth/domain/models/user.dart';

/// Interface for the Authentication Repository
abstract class AuthRepository {
  /// Gets the current user if signed in
  Future<User?> getCurrentUser();

  /// Signs in with email and password
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user with email and password
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Signs out the current user
  Future<void> signOut();

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail({required String email});

  /// Updates the user profile
  Future<User> updateProfile({String? displayName, String? photoUrl});

  /// Checks if there is a current user signed in
  Future<bool> isSignedIn();

  /// Inicia sesión con Google
  Future<User> signInWithGoogle();
}
