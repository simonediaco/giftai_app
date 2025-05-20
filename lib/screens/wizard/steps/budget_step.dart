import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BudgetStep extends StatefulWidget {
  final String selectedBudget;
  final Function(String) onBudgetChanged;

  const BudgetStep({
    super.key,
    required this.selectedBudget,
    required this.onBudgetChanged,
  });

  @override
  State<BudgetStep> createState() => _BudgetStepState();
}

class _BudgetStepState extends State<BudgetStep> {
  late String _selectedBudget;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  
  final List<String> _predefinedBudgets = [
    '0-30€',
    '30-50€',
    '50-100€',
    '100-200€',
    '200-500€',
    '500-1000€',
    '1000€+',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBudget = widget.selectedBudget;
    
    // Inizializza i controller se il budget è personalizzato
    if (!_predefinedBudgets.contains(_selectedBudget) && _selectedBudget.contains('-')) {
      final parts = _selectedBudget.replaceAll('€', '').split('-');
      if (parts.length == 2) {
        _minController.text = parts[0].trim();
        _maxController.text = parts[1].trim();
      }
    }
  }
  
  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }
  
  void _selectBudget(String budget) {
    setState(() {
      _selectedBudget = budget;
      widget.onBudgetChanged(budget);
    });
  }
  
  void _setCustomBudget() {
    final min = _minController.text.trim();
    final max = _maxController.text.trim();
    if (min.isNotEmpty && max.isNotEmpty) {
      final customBudget = '$min-$max€';
      setState(() {
        _selectedBudget = customBudget;
        widget.onBudgetChanged(customBudget);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Qual è il tuo budget?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seleziona il budget che vuoi spendere per questo regalo',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Budget rapidi
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _predefinedBudgets.map((budget) {
              final isSelected = _selectedBudget == budget;
              return ChoiceChip(
                label: Text(budget),
                selected: isSelected,
                onSelected: (_) => _selectBudget(budget),
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Budget personalizzato
          const Text(
            'Budget personalizzato',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'min_budget',
                  controller: _minController,
                  decoration: const InputDecoration(
                    labelText: 'Min €',
                    prefixText: '€',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  name: 'max_budget',
                  controller: _maxController,
                  decoration: const InputDecoration(
                    labelText: 'Max €',
                    prefixText: '€',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _setCustomBudget,
                icon: const Icon(Icons.check_circle),
                color: Theme.of(context).colorScheme.primary,
                tooltip: 'Imposta budget personalizzato',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Visualizzazione budget selezionato
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget selezionato',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedBudget,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}