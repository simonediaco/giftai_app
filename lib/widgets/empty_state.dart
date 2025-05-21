import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget per visualizzare uno stato vuoto con icona, titolo e descrizione
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  
  // Parametri opzionali per compatibilità
  final String? actionText;
  final VoidCallback? onActionPressed;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icona
            Icon(
              icon,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            )
            .animate()
            .scale(
              duration: 400.ms, 
              curve: Curves.easeOutBack,
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
            ),
            
            const SizedBox(height: 24),
            
            // Titolo
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 200.ms),
            
            const SizedBox(height: 16),
            
            // Messaggio
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms),
            
            // Azione opzionale
            if (action != null) ...[
              const SizedBox(height: 32),
              action!
                .animate()
                .fadeIn(duration: 400.ms, delay: 600.ms)
                .scale(
                  duration: 400.ms, 
                  delay: 600.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                ),
            ],
          ],
        ),
      ),
    );
  }
}