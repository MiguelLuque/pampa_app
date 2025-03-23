import 'package:flutter/material.dart';

/// Clase para centralizar todos los estilos de la aplicación
///
/// Esta clase proporciona acceso a estilos consistentes en toda la app,
/// facilitando cambios globales y manteniendo la coherencia visual.
class AppStyles {
  static TextStyle get titleLarge => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get titleMedium =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static TextStyle get titleSmall =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get bodyMedium => const TextStyle(fontSize: 14);

  static TextStyle get bodySmall => const TextStyle(fontSize: 12);

  static TextStyle get labelSmall => const TextStyle(fontSize: 11);

  static TextStyle get subtitle =>
      TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9));

  static TextStyle get price =>
      TextStyle(fontSize: 14, color: Colors.black.withValues(alpha: 0.7));

  static TextStyle get badge =>
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  // Estilos para botones y elementos interactivos
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  // Estilos para tarjetas y contenedores
  static BoxDecoration get cardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 2),
        blurRadius: 6,
      ),
    ],
  );

  static BorderRadius get borderRadius => BorderRadius.circular(16);

  static BorderRadius get pillBorderRadius => BorderRadius.circular(20);

  // Estilos para indicadores
  static BoxDecoration indicatorDecoration({
    required bool isActive,
    required Color activeColor,
  }) => BoxDecoration(
    shape: BoxShape.circle,
    color: isActive ? activeColor : Colors.grey.withValues(alpha: 0.3),
  );

  // Estilos para navegación
  static BoxDecoration get navigationIconDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.9),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5),
    ],
  );

  // Estilos para badges
  static BoxDecoration get badgeDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(20),
  );

  // Dimensiones estándar
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;

  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 40.0;

  static const double indicatorSize = 8.0;

  // Duración de animaciones
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeIn;
}
