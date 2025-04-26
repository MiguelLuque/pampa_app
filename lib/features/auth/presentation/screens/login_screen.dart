import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/auth/application/auth_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final authState = ref.watch(authStateProvider);
    final isPasswordVisible = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: const Color(0xFF6EBCB5),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppStyles.paddingMedium),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // Bienvenido text
                    Text(
                      'Bienvenido a Pampa',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Panadería Artesanal Argentina',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    // Email field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Correo Electrónico'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'tu@email.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo electrónico';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Por favor ingresa un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contraseña'),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPasswordVisible,
                          builder: (context, isVisible, _) {
                            return TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: '********',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    isPasswordVisible.value = !isVisible;
                                  },
                                ),
                              ),
                              obscureText: !isVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: Colors.teal,
                        ),
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            authState.isLoading
                                ? null
                                : () async {
                                  if (formKey.currentState!.validate()) {
                                    await ref
                                        .read(authStateProvider.notifier)
                                        .signIn(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );

                                    if (!ref.read(authStateProvider).hasError &&
                                        context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EBCB5),
                          disabledBackgroundColor: const Color(0xFF6EBCB5),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            authState.isLoading
                                ? const Center(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login),
                                    SizedBox(width: 8),
                                    Text('Iniciar Sesión'),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Or divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'o',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Image.asset(
                          'assets/images/google_g_icon.png',
                          width: 24,
                          height: 24,
                        ),
                        label:
                            authState.isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Continuar con Google'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed:
                            authState.isLoading
                                ? null
                                : () async {
                                  await ref
                                      .read(authStateProvider.notifier)
                                      .signInWithGoogle();
                                  if (!ref.read(authStateProvider).hasError &&
                                      context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.register,
                            );
                          },
                          child: const Text('Crear Cuenta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
