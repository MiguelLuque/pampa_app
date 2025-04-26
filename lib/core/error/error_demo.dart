import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/error/app_error_handler.dart';

/// Helper para mostrar errores de demostración
class ErrorDemo {
  /// Muestra un error de demostración del tipo especificado
  static void showDemoError(
    WidgetRef ref,
    ErrorType type, [
    String? customMessage,
  ]) {
    final errorNotifier = ref.read(appErrorProvider.notifier);

    errorNotifier.reportError(
      AppError(
        message: customMessage,
        type: type,
        exception: Exception('Demo error'),
        stackTrace: StackTrace.current,
      ),
    );
  }
}

/// Widget para crear botones de demostración de errores
class ErrorDemoButtons extends ConsumerWidget {
  const ErrorDemoButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Demostración de Errores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildErrorButton(
                  context,
                  ref,
                  'Error de Red',
                  ErrorType.network,
                ),
                _buildErrorButton(
                  context,
                  ref,
                  'Error de Autenticación',
                  ErrorType.authentication,
                ),
                _buildErrorButton(
                  context,
                  ref,
                  'Error de Validación',
                  ErrorType.validation,
                ),
                _buildErrorButton(
                  context,
                  ref,
                  'Error de Base de Datos',
                  ErrorType.database,
                ),
                _buildErrorButton(
                  context,
                  ref,
                  'Error de Firebase',
                  ErrorType.firebase,
                ),
                _buildErrorButton(
                  context,
                  ref,
                  'Error General',
                  ErrorType.general,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    ErrorType type,
  ) {
    return ElevatedButton(
      onPressed: () => ErrorDemo.showDemoError(ref, type),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getColorForType(type),
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  Color _getColorForType(ErrorType type) {
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
}
