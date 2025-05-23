// lib/features/gift_ideas/presentation/widgets/wizard_continue_button.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WizardContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String text;
  
  const WizardContinueButton({
    Key? key,
    required this.onPressed,
    this.isEnabled = true,
    this.text = 'Continua',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXL),
              ),
              elevation: isEnabled ? 4 : 0,
              shadowColor: theme.colorScheme.primary.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isEnabled ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}