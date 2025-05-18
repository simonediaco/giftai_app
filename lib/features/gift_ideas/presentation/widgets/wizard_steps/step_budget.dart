// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_budget.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../models/gift_wizard_data.dart';

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
  final List<Map<String, dynamic>> _budgetRanges = [
    {
      'range': '0-20',
      'label': 'Economico',
      'icon': Icons.euro,
      'priceSymbols': '€',
      'color': Colors.green,
    },
    {
      'range': '20-50',
      'label': 'Contenuto',
      'icon': Icons.euro,
      'priceSymbols': '€€',
      'color': Colors.lightGreen,
    },
    {
      'range': '50-100',
      'label': 'Medio',
      'icon': Icons.euro,
      'priceSymbols': '€€€',
      'color': Colors.amber,
    },
    {
      'range': '100-200',
      'label': 'Premium',
      'icon': Icons.euro,
      'priceSymbols': '€€€€',
      'color': Colors.orange,
    },
    {
      'range': '200+',
      'label': 'Lusso',
      'icon': Icons.euro,
      'priceSymbols': '€€€€€',
      'color': Colors.red,
    },
  ];

  // Slider per range di prezzo specifico
  double _minValue = 0;
  double _maxValue = 200;
  RangeValues _currentRangeValues = const RangeValues(20, 100);

  @override
  void initState() {
    super.initState();
    // Inizializza dai dati esistenti se disponibili
    if (widget.wizardData.budget != null) {
      final parts = widget.wizardData.budget!.split('-');
      if (parts.length == 2) {
        _currentRangeValues = RangeValues(
          double.tryParse(parts[0]) ?? 20,
          double.tryParse(parts[1].replaceAll('+', '')) ?? 100,
        );
      }
    }
  }

  void _updateCustomRange() {
    final start = _currentRangeValues.start.round();
    final end = _currentRangeValues.end.round();
    
    // Per valori oltre 200, usa il formato "200+"
    final endValue = end >= 200 ? '200+' : end.toString();
    
    setState(() {
      widget.wizardData.budget = '$start-$endValue';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleziona il budget',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          
          // Opzioni budget predefinite
          ...List.generate(_budgetRanges.length, (index) => 
            _buildBudgetOption(_budgetRanges[index])
          ),
          
          const SizedBox(height: AppTheme.spaceL),
          
          // Divisore
          const Divider(),
          const SizedBox(height: AppTheme.spaceL),
          
          // Range personalizzato
          Text(
            'Oppure specifica un range personalizzato',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppTheme.spaceM),
          
          // Price slider
          RangeSlider(
            values: _currentRangeValues,
            min: _minValue,
            max: _maxValue,
            divisions: 40,
            labels: RangeLabels(
              '${_currentRangeValues.start.round()}€',
              _currentRangeValues.end >= 200 ? '200+€' : '${_currentRangeValues.end.round()}€',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
            onChangeEnd: (RangeValues values) {
              _updateCustomRange();
            },
          ),
          
          // Display selected range
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceM,
                vertical: AppTheme.spaceS,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
              ),
              child: Text(
                'Range: ${_currentRangeValues.start.round()}€ - ${_currentRangeValues.end >= 200 ? '200+€' : '${_currentRangeValues.end.round()}€'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spaceXL),
          
          // Pulsante Continua
          Center(
            child: AppButton(
              text: 'Trova Regalo',
              icon: const Icon(Icons.search),
              onPressed: widget.wizardData.isBudgetComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBudgetOption(Map<String, dynamic> budget) {
    final isSelected = widget.wizardData.budget == budget['range'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.wizardData.budget = budget['range'];
            
            // Aggiorna anche il range slider
            final parts = budget['range'].split('-');
            if (parts.length == 2) {
              double start = double.tryParse(parts[0]) ?? 0;
              double end = parts[1].contains('+') 
                  ? 200 // imposta al massimo per "200+"
                  : double.tryParse(parts[1]) ?? 100;
              
              _currentRangeValues = RangeValues(start, end);
            }
          });
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: isSelected ? budget['color'] : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? budget['color'].withOpacity(0.1) : null,
          ),
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: budget['color'].withOpacity(isSelected ? 1.0 : 0.2),
                ),
                child: Center(
                  child: Text(
                    budget['priceSymbols'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : budget['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget['label'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${budget['range']}€',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: budget['color'],
                ),
            ],
          ),
        ),
      ),
    );
  }
}