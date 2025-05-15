import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum AppButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double height;
  final double? width;
  final double borderRadius;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.height = 50,
    this.width,
    this.borderRadius = AppTheme.borderRadiusM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppButtonType.secondary:
        return _secondaryButton(context);
      case AppButtonType.text:
        return _textButton(context);
      case AppButtonType.primary:
      default:
        return _primaryButton(context);
    }
  }

  Widget _primaryButton(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buttonContent(context, Colors.white),
      ),
    );
  }

  Widget _secondaryButton(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: _buttonContent(
          context,
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _textButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buttonContent(
        context,
        Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buttonContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.primary ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppTheme.spaceS),
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(color: textColor),
    );
  }
}