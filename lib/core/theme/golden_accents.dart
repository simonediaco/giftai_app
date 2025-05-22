import 'package:flutter/material.dart';

/// Sistema di accenti dorati per Donatello
/// Ispirato alle decorazioni dorate delle opere rinascimentali
class GoldenAccents {
  // Palette oro principale
  static const Color primary = Color(0xFFFFD700);    // Gold classico
  static const Color rich = Color(0xFFB8860B);       // Dark Golden Rod
  static const Color light = Color(0xFFFFF8DC);      // Cornsilk
  static const Color champagne = Color(0xFFF7E7CE);  // Champagne
  static const Color bronze = Color(0xFFCD7F32);     // Bronze
  
  // Gradiente oro per elementi premium
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente oro soft per sfondi
  static const LinearGradient goldSoftGradient = LinearGradient(
    colors: [Color(0xFFFFF8DC), Color(0xFFF7E7CE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Crea un widget con accent oro per elementi premium/VIP
  static Widget premiumBadge({
    required Widget child,
    bool showGlow = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: showGlow ? [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ] : null,
      ),
      child: child,
    );
  }
  
  /// Crea un bordo dorato elegante
  static BoxDecoration goldenBorder({
    double borderRadius = 12,
    double borderWidth = 2,
    bool withShadow = false,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: primary,
        width: borderWidth,
      ),
      boxShadow: withShadow ? [
        BoxShadow(
          color: primary.withValues(alpha: 0.2),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ] : null,
    );
  }
  
  /// Testo con effetto oro
  static TextStyle goldenText(TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: primary,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: rich.withValues(alpha: 0.5),
          offset: const Offset(1, 1),
          blurRadius: 2,
        ),
      ],
    );
  }
  
  /// Icona con effetto oro
  static Widget goldenIcon(
    IconData icon, {
    double size = 24,
    bool withGlow = false,
  }) {
    return Container(
      decoration: withGlow ? BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ) : null,
      child: Icon(
        icon,
        color: primary,
        size: size,
        shadows: [
          Shadow(
            color: rich.withValues(alpha: 0.5),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
  
  /// Badge oro per match perfetti (90%+)
  static Widget perfectMatchBadge(int matchPercentage) {
    if (matchPercentage < 90) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events, // Trofeo
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'PERFECT',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Bottone premium con oro
  static Widget premiumButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}