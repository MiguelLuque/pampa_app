import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/error/app_error_handler.dart';

/// Utilidades para manejar errores comunes en la aplicación
class ErrorUtils {
  /// Convierte excepciones comunes en AppError con el tipo apropiado
  static AppError handleException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is FirebaseAuthException) {
      return _handleFirebaseAuthError(exception, stackTrace);
    } else if (exception is FirebaseException) {
      return _handleFirebaseError(exception, stackTrace);
    } else if (exception is SocketException || exception is TimeoutException) {
      return AppError(
        type: ErrorType.network,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is HttpException) {
      return AppError(
        message: 'Error HTTP: ${exception.message}',
        type: ErrorType.network,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is PlatformException) {
      return AppError(
        message: exception.message,
        type: ErrorType.general,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is FormatException) {
      return AppError(
        type: ErrorType.validation,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else {
      return AppError(
        type: ErrorType.general,
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  /// Maneja errores específicos de Firebase Auth
  static AppError _handleFirebaseAuthError(
    FirebaseAuthException exception,
    StackTrace? stackTrace,
  ) {
    String? message;

    switch (exception.code) {
      case 'user-not-found':
        message = 'No existe una cuenta con este correo electrónico.';
        break;
      case 'wrong-password':
        message = 'La contraseña es incorrecta.';
        break;
      case 'email-already-in-use':
        message = 'Ya existe una cuenta con este correo electrónico.';
        break;
      case 'weak-password':
        message =
            'La contraseña es demasiado débil. Usa al menos 6 caracteres.';
        break;
      case 'invalid-email':
        message = 'El correo electrónico no es válido.';
        break;
      case 'user-disabled':
        message = 'Esta cuenta ha sido deshabilitada.';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos fallidos. Intenta más tarde.';
        break;
      default:
        // Usaremos el mensaje predeterminado para autenticación
        break;
    }

    return AppError(
      message: message,
      type: ErrorType.authentication,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Maneja errores de Firebase (no auth)
  static AppError _handleFirebaseError(
    FirebaseException exception,
    StackTrace? stackTrace,
  ) {
    return AppError(
      type: ErrorType.firebase,
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}

/// Extension para AsyncValue que facilita el manejo de errores
extension AsyncValueErrorExtension<T> on AsyncValue<T> {
  /// Devuelve un AppError si el AsyncValue contiene un error, o null en caso contrario
  AppError? get appError {
    return whenOrNull(
      error: (error, stack) => ErrorUtils.handleException(error, stack),
    );
  }

  /// Reporta el error si existe en el provider de errores
  void reportErrorIfExists(WidgetRef ref) {
    final error = appError;
    if (error != null) {
      ref.read(appErrorProvider.notifier).reportError(error);
    }
  }
}

/// Método para ejecutar código y capturar errores automáticamente
Future<T?> runCatching<T>({
  required Future<T> Function() action,
  required AppErrorNotifier errorNotifier,
}) async {
  try {
    return await action();
  } catch (e, stack) {
    final appError = ErrorUtils.handleException(e, stack);
    errorNotifier.reportError(appError);
    return null;
  }
}
