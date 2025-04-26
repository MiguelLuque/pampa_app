import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/error/app_error_handler.dart';
import 'package:pampa_app/core/error/error_display_widget.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_theme.dart';
import 'package:pampa_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pampa_app/features/auth/presentation/screens/login_screen.dart';
import 'package:pampa_app/features/auth/presentation/screens/register_screen.dart';
import 'package:pampa_app/features/home/presentation/screens/home_screen.dart';
import 'package:pampa_app/features/product_detail/presentation/screens/product_detail_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar el observer para Riverpod
  final providerContainer = ProviderContainer(
    observers: [ProviderErrorObserver()],
  );

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Pampa App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      // Envolver toda la aplicación con el widget de manejo de errores
      builder: (context, child) {
        return ErrorDisplayWidget(child: child ?? const SizedBox.shrink());
      },
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.productDetail: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final productId = args['productId'] as String;
          return ProductDetailView(productId: productId);
        },
        AppRoutes.productDetailDemo: (context) => const ProductDetailDemoView(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
