import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BudgetOption extends StatelessWidget {
  final int minPrice;
  final int maxPrice;
  final bool isSelected;
  final VoidCallback onTap;

  const BudgetOption({
    Key? key,
    required this.minPrice,
    required this.maxPrice,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected 
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Row(
            children: [
              Icon(
                Icons.euro,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: AppTheme.spaceM),
              Text(
                '${minPrice}€ - ${maxPrice}€',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}