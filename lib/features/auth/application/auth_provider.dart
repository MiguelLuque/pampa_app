import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/firebase_auth_repository.dart';
import '../domain/models/user.dart';
import '../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

/// Provider for the Auth Repository
@riverpod
AuthRepository authRepository(ref) {
  return FirebaseAuthRepository();
}

/// Provider for the current user, refreshes when auth state changes
@riverpod
Future<User?> currentUser(ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
}

/// Auth state notifier for managing authentication state
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    return ref.watch(authRepositoryProvider).getCurrentUser();
  }

  /// Signs in a user with email and password
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Creates a new user with email and password
  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Updates the user profile
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (state.value == null) return;

    try {
      final repository = ref.read(authRepositoryProvider);
      final updatedUser = await repository.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      state = AsyncValue.data(updatedUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendPasswordResetEmail(email: email);
    } catch (error) {
      rethrow;
    }
  }

  /// Inicia sesión con Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
