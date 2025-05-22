import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../models/gift_wizard_data.dart';
import '../budget_option.dart';

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
  final List<Map<String, int>> budgetRanges = [
    {'min': 0, 'max': 50},
    {'min': 50, 'max': 100},
    {'min': 100, 'max': 200},
    {'min': 200, 'max': 500},
    {'min': 500, 'max': 1000},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: budgetRanges.length,
              itemBuilder: (context, index) {
                final range = budgetRanges[index];
                final isSelected = widget.wizardData.minPrice == range['min'] && 
                                 widget.wizardData.maxPrice == range['max'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                  child: BudgetOption(
                    minPrice: range['min']!,
                    maxPrice: range['max']!,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        widget.wizardData.minPrice = range['min'];
                        widget.wizardData.maxPrice = range['max'];
                      });
                      widget.onComplete();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}