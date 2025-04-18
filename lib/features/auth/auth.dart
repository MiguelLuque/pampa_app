/// Barrel file to export all auth related files
///
/// This makes imports cleaner in other files

// Application / Providers
export 'application/auth_provider.dart';

// Domain
export 'domain/models/user.dart';
export 'domain/repositories/auth_repository.dart';

// Data
export 'data/repositories/firebase_auth_repository.dart';

// Presentation
export 'presentation/screens/login_screen.dart';
export 'presentation/screens/register_screen.dart';
export 'presentation/screens/forgot_password_screen.dart';
