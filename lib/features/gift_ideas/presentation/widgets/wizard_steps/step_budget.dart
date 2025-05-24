// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_budget.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepBudget extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepBudget({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepBudget> createState() => _StepBudgetState();
}

class _StepBudgetState extends State<StepBudget> {
  String? _selectedBudgetId;
  bool _isCustom = false;
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  
  final List<Map<String, dynamic>> _budgetOptions = [
    {
      'id': 'mini',
      'min': 0,
      'max': 25,
      'label': 'Piccolo pensiero',
      'range': '€0 - €25',
      'color': Colors.green,
    },
    {
      'id': 'small',
      'min': 25,
      'max': 50,
      'label': 'Regalo casual',
      'range': '€25 - €50',
      'color': Colors.blue,
    },
    {
      'id': 'medium',
      'min': 50,
      'max': 100,
      'label': 'Regalo speciale',
      'range': '€50 - €100',
      'color': Colors.purple,
    },
    {
      'id': 'large',
      'min': 100,
      'max': 200,
      'label': 'Regalo importante',
      'range': '€100 - €200',
      'color': Colors.orange,
    },
    {
      'id': 'xlarge',
      'min': 200,
      'max': 500,
      'label': 'Regalo di lusso',
      'range': '€200 - €500',
      'color': Colors.pink,
    },
    {
      'id': 'premium',
      'min': 500,
      'max': 1000,
      'label': 'Regalo premium',
      'range': '€500 - €1000',
      'color': Colors.amber,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Se ci sono già valori salvati
    if (widget.wizardData.minPrice != null && widget.wizardData.maxPrice != null) {
      final savedMin = widget.wizardData.minPrice!;
      final savedMax = widget.wizardData.maxPrice!;
      
      // Controlla se corrisponde a un preset
      bool foundPreset = false;
      for (final option in _budgetOptions) {
        if (option['min'] == savedMin && option['max'] == savedMax) {
          _selectedBudgetId = option['id'];
          foundPreset = true;
          break;
        }
      }
      
      // Se non è un preset, è custom
      if (!foundPreset) {
        _isCustom = true;
        _minController.text = savedMin.toString();
        _maxController.text = savedMax.toString();
      }
    }
  }
  
  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }
  
  void _selectBudget(Map<String, dynamic> option) {
    setState(() {
      _selectedBudgetId = option['id'];
      _isCustom = false;
      widget.wizardData.minPrice = option['min'];
      widget.wizardData.maxPrice = option['max'];
      _minController.clear();
      _maxController.clear();
    });
  }
  
  void _selectCustom() {
    setState(() {
      _isCustom = true;
      _selectedBudgetId = null;
    });
  }
  
  void _updateCustomValues() {
    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);
    
    if (min != null && max != null && min < max) {
      widget.wizardData.minPrice = min;
      widget.wizardData.maxPrice = max;
    }
  }
  
  bool get _canContinue {
    if (_isCustom) {
      final min = int.tryParse(_minController.text);
      final max = int.tryParse(_maxController.text);
      return min != null && max != null && min < max;
    }
    return _selectedBudgetId != null;
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
                // Header
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceM),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.euro,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: Text(
                          'Seleziona il budget o inserisci un importo personalizzato',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spaceL),
                
                // Opzioni predefinite
                Text(
                  'Budget suggeriti',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                
                ..._budgetOptions.map((option) {
                  final isSelected = _selectedBudgetId == option['id'] && !_isCustom;
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
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconForBudget(option['id']),
                                  color: color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spaceL),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['label'],
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      option['range'],
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? color
                                            : theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                
                // Divider
                const SizedBox(height: AppTheme.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM),
                      child: Text(
                        'oppure',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Budget personalizzato
                Text(
                  'Budget personalizzato',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                
                InkWell(
                  onTap: _selectCustom,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    decoration: BoxDecoration(
                      color: _isCustom
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      border: Border.all(
                        color: _isCustom
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3),
                        width: _isCustom ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spaceL),
                            Expanded(
                              child: Text(
                                'Inserisci il tuo budget',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_isCustom)
                              Icon(
                                Icons.check_circle,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                          ],
                        ),
                        
                        // Campi input
                        if (_isCustom) ...[
                          const SizedBox(height: AppTheme.spaceL),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _minController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Da €',
                                    hintText: '0',
                                    filled: true,
                                    fillColor: theme.scaffoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.euro),
                                  ),
                                  onChanged: (_) => setState(_updateCustomValues),
                                ),
                              ),
                              const SizedBox(width: AppTheme.spaceM),
                              Expanded(
                                child: TextFormField(
                                  controller: _maxController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'A €',
                                    hintText: '100',
                                    filled: true,
                                    fillColor: theme.scaffoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.euro),
                                  ),
                                  onChanged: (_) => setState(_updateCustomValues),
                                ),
                              ),
                            ],
                          ),
                          
                          // Validazione
                          if (_minController.text.isNotEmpty && _maxController.text.isNotEmpty) ...[
                            const SizedBox(height: AppTheme.spaceS),
                            if (!_canContinue)
                              Text(
                                'Il valore minimo deve essere inferiore al massimo',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottone continua
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: _canContinue,
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