import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BudgetOption extends StatelessWidget {
  final String label;
  final String description;
  final int priceLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const BudgetOption({
    Key? key,
    required this.label,
    required this.description,
    required this.priceLevel,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? AppTheme.elevationL : AppTheme.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Row(
            children: [
              // Badge del prezzo
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: _buildPriceIcon(context),
              ),
              const SizedBox(width: AppTheme.spaceM),
              
              // Testo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Icona di selezione
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceIcon(BuildContext context) {
    final icons = List.generate(
      priceLevel,
      (index) => Icon(
        Icons.euro,
        size: 16,
        color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }
}