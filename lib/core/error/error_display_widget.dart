import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/error/app_error_handler.dart';

class ErrorDisplayWidget extends ConsumerWidget {
  final Widget child;

  const ErrorDisplayWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(appErrorProvider);

    return Stack(
      children: [
        child,
        if (error != null)
          AnimatedErrorBanner(
            error: error,
            onDismiss: () => ref.read(appErrorProvider.notifier).clearError(),
          ),
      ],
    );
  }
}

class AnimatedErrorBanner extends StatefulWidget {
  final AppError error;
  final VoidCallback onDismiss;
  final Duration duration;

  const AnimatedErrorBanner({
    super.key,
    required this.error,
    required this.onDismiss,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<AnimatedErrorBanner> createState() => _AnimatedErrorBannerState();
}

class _AnimatedErrorBannerState extends State<AnimatedErrorBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Configurar cierre automático
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismissBanner();
      }
    });
  }

  void _dismissBanner() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ErrorBanner(error: widget.error, onDismiss: _dismissBanner),
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final AppError error;
  final VoidCallback onDismiss;

  const ErrorBanner({super.key, required this.error, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: _getBackgroundColorForType(error.type),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(_getIconForType(error.type), color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getTitleForType(error.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error.message,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColorForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange.shade800;
      case ErrorType.authentication:
        return Colors.red.shade700;
      case ErrorType.validation:
        return Colors.amber.shade800;
      case ErrorType.database:
        return Colors.indigo.shade800;
      case ErrorType.firebase:
        return Colors.deepOrange.shade800;
      case ErrorType.general:
        return Colors.red.shade900;
    }
  }

  IconData _getIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.signal_wifi_off;
      case ErrorType.authentication:
        return Icons.lock;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.database:
        return Icons.storage;
      case ErrorType.firebase:
        return Icons.cloud_off;
      case ErrorType.general:
        return Icons.error;
    }
  }

  String _getTitleForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Error de conexión';
      case ErrorType.authentication:
        return 'Error de autenticación';
      case ErrorType.validation:
        return 'Error de validación';
      case ErrorType.database:
        return 'Error de base de datos';
      case ErrorType.firebase:
        return 'Error de Firebase';
      case ErrorType.general:
        return 'Error';
    }
  }
}
