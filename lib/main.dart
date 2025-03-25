import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_theme.dart';
import 'package:pampa_app/features/home/presentation/screens/home_screen.dart';
import 'package:pampa_app/features/product_detail/presentation/screens/product_detail_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pampa App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
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
      },
    );
  }
}
