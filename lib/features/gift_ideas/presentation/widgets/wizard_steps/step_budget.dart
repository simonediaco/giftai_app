import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
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
  final List<BudgetRange> _budgetRanges = [
    BudgetRange(
      label: '0-20€',
      description: 'Economico',
      icon: Icons.euro,
      priceLevel: 1,
    ),
    BudgetRange(
      label: '20-50€',
      description: 'Accessibile',
      icon: Icons.euro,
      priceLevel: 2,
    ),
    BudgetRange(
      label: '50-100€',
      description: 'Medio',
      icon: Icons.euro,
      priceLevel: 3,
    ),
    BudgetRange(
      label: '100-200€',
      description: 'Premium',
      icon: Icons.euro,
      priceLevel: 4,
    ),
    BudgetRange(
      label: '200€+',
      description: 'Lusso',
      icon: Icons.euro,
      priceLevel: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Testo introduttivo
          Text(
            'Scegli quanto vorresti spendere per questo regalo',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spaceL),
          
          // Opzioni di budget
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _budgetRanges.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spaceM),
            itemBuilder: (context, index) {
              final budget = _budgetRanges[index];
              final isSelected = widget.wizardData.budget == budget.label;
              
              return BudgetOption(
                label: budget.label,
                description: budget.description,
                priceLevel: budget.priceLevel,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    widget.wizardData.budget = budget.label;
                  });
                },
              );
            },
          ),
          const SizedBox(height: AppTheme.spaceXL),
          
          // Pulsante finale
          Center(
            child: AppButton(
              text: 'Trova il Regalo Perfetto',
              icon: const Icon(Icons.search),
              onPressed: widget.wizardData.isStepFiveComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetRange {
  final String label;
  final String description;
  final IconData icon;
  final int priceLevel;
  
  BudgetRange({
    required this.label,
    required this.description,
    required this.icon,
    required this.priceLevel,
  });
}