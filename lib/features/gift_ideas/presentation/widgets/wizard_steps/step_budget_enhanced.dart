// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_budget_enhanced.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepBudgetEnhanced extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepBudgetEnhanced({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepBudgetEnhanced> createState() => _StepBudgetEnhancedState();
}

class _StepBudgetEnhancedState extends State<StepBudgetEnhanced> {
  String? _selectedBudgetId;
  
  final List<Map<String, dynamic>> _budgetOptions = [
    {
      'id': 'mini',
      'min': '0',
      'max': '25',
      'label': 'Piccolo pensiero',
      'range': '€0 - €25',
      'color': Colors.green,
    },
    {
      'id': 'small',
      'min': '25',
      'max': '50',
      'label': 'Regalo casual',
      'range': '€25 - €50',
      'color': Colors.blue,
    },
    {
      'id': 'medium',
      'min': '50',
      'max': '100',
      'label': 'Regalo speciale',
      'range': '€50 - €100',
      'color': Colors.purple,
    },
    {
      'id': 'large',
      'min': '100',
      'max': '200',
      'label': 'Regalo importante',
      'range': '€100 - €200',
      'color': Colors.orange,
    },
    {
      'id': 'xlarge',
      'min': '200',
      'max': '500',
      'label': 'Regalo di lusso',
      'range': '€200 - €500',
      'color': Colors.pink,
    },
    {
      'id': 'premium',
      'min': '500',
      'max': '1000',
      'label': 'Senza limiti',
      'range': 'Oltre €500',
      'color': Colors.amber,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Se ci sono già valori salvati, trova l'opzione corrispondente
    if (widget.wizardData.minPrice != null && widget.wizardData.maxPrice != null) {
      for (final option in _budgetOptions) {
        if (option['min'] == widget.wizardData.minPrice &&
            option['max'] == widget.wizardData.maxPrice) {
          _selectedBudgetId = option['id'];
          break;
        }
      }
    }
  }
  
  void _selectBudget(Map<String, dynamic> option) {
    setState(() {
      _selectedBudgetId = option['id'];
      widget.wizardData.minPrice = option['min'];
      widget.wizardData.maxPrice = option['max'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              children: [
                // Header informativo
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceM),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: Text(
                          'Seleziona il budget per trovare il regalo perfetto',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spaceL),
                
                // Opzioni budget
                ..._budgetOptions.map((option) {
                  final isSelected = _selectedBudgetId == option['id'];
                  final color = option['color'] as Color;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectBudget(option),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(AppTheme.spaceL),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.1)
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.outline.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? color.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icona budget
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconForBudget(option['id']),
                                  color: isSelected ? color : color,
                                  size: 28,
                                ),
                              ),
                              
                              const SizedBox(width: AppTheme.spaceL),
                              
                              // Testi
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['label'],
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: isSelected ? color : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['range'],
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? color.withOpacity(0.8)
                                            : theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Check
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: color,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: _selectedBudgetId != null,
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForBudget(String id) {
    switch (id) {
      case 'mini':
        return Icons.card_giftcard;
      case 'small':
        return Icons.redeem;
      case 'medium':
        return Icons.celebration;
      case 'large':
        return Icons.star;
      case 'xlarge':
        return Icons.diamond;
      case 'premium':
        return Icons.workspace_premium;
      default:
        return Icons.euro;
    }
  }
}