import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Tipos de errores que puede manejar la aplicación
enum ErrorType {
  network,
  authentication,
  validation,
  database,
  firebase,
  general,
}

/// Extensión para obtener mensajes predeterminados amigables para cada tipo de error
extension ErrorTypeMessages on ErrorType {
  /// Mensaje predeterminado amigable para el usuario
  String get defaultMessage {
    switch (this) {
      case ErrorType.network:
        return 'No ha sido posible conectar con el servidor. Por favor, verifica tu conexión a Internet e intenta nuevamente.';
      case ErrorType.authentication:
        return 'Ha ocurrido un problema con tu cuenta. Por favor, inicia sesión nuevamente.';
      case ErrorType.validation:
        return 'Algunos datos ingresados no son válidos. Por favor, verifica la información e inténtalo de nuevo.';
      case ErrorType.database:
        return 'No se ha podido acceder a la información. Por favor, intenta nuevamente en unos momentos.';
      case ErrorType.firebase:
        return 'Ha ocurrido un problema con el servicio. Por favor, intenta nuevamente más tarde.';
      case ErrorType.general:
        return 'Ha ocurrido un error inesperado. Por favor, intenta nuevamente.';
    }
  }
}

/// Modelo para representar errores de manera uniforme
class AppError {
  final String message;
  final ErrorType type;
  final dynamic exception;
  final StackTrace? stackTrace;

  AppError({
    String? message,
    required this.type,
    this.exception,
    this.stackTrace,
  }) : message = message ?? type.defaultMessage;

  @override
  String toString() => 'AppError(type: $type, message: $message)';
}

/// Provider global para gestionar errores
final appErrorProvider = StateNotifierProvider<AppErrorNotifier, AppError?>(
  (ref) => AppErrorNotifier(),
);

class AppErrorNotifier extends StateNotifier<AppError?> {
  AppErrorNotifier() : super(null);

  void reportError(AppError error) {
    // Log el error
    dev.log(
      'ERROR: ${error.message}',
      error: error.exception,
      stackTrace: error.stackTrace,
      name: 'AppErrorHandler',
    );

    // Actualizar el estado con el error
    state = error;
  }

  void clearError() {
    state = null;
  }
}

/// Observer para capturar errores de los providers
class ProviderErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final appErrorNotifier = container.read(appErrorProvider.notifier);
    //si error es app error usamos el que viene, si no, devolvemos un default como ahora
    final appError =
        error is AppError
            ? error
            : AppError(
              type: ErrorType.general,
              exception: error,
              stackTrace: stackTrace,
            );
    appErrorNotifier.reportError(appError);

    super.providerDidFail(provider, error, stackTrace, container);
  }
}

/// Extensión para transformar excepciones en AppError
extension ErrorHandling on Exception {
  AppError toAppError({
    ErrorType type = ErrorType.general,
    String? customMessage,
    StackTrace? stackTrace,
  }) {
    return AppError(
      message: customMessage,
      type: type,
      exception: this,
      stackTrace: stackTrace,
    );
  }
}
