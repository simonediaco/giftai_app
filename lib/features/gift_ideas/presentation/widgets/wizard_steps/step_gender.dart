// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_gender.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../models/gift_wizard_data.dart';

class StepGender extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepGender({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepGender> createState() => _StepGenderState();
}

class _StepGenderState extends State<StepGender> {
  final List<Map<String, dynamic>> _genderOptions = [
    {
      'value': 'M',
      'label': 'Uomo',
      'icon': Icons.male,
      'color': Colors.blue,
      'description': 'Maschile'
    },
    {
      'value': 'F',
      'label': 'Donna',
      'icon': Icons.female,
      'color': Colors.pink,
      'description': 'Femminile'
    },
    {
      'value': 'N',
      'label': 'Non binario',
      'icon': Icons.transgender,
      'color': Colors.purple,
      'description': 'Non binario'
    },
    {
      'value': 'X',
      'label': 'Non specificato',
      'icon': Icons.person,
      'color': Colors.grey,
      'description': 'Preferisco non specificare'
    },
    {
      'value': 'O',
      'label': 'Altro',
      'icon': Icons.people,
      'color': Colors.teal,
      'description': 'Altra identità di genere'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleziona il genere',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          
          // Opzioni genere
          ...List.generate(_genderOptions.length, (index) {
            final option = _genderOptions[index];
            return _buildGenderOption(option);
          }),
          
          const SizedBox(height: AppTheme.spaceXL),
          
          // Pulsante Continua
          Center(
            child: AppButton(
              text: 'Continua',
              icon: const Icon(Icons.arrow_forward),
              onPressed: widget.wizardData.isStepTwoComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGenderOption(Map<String, dynamic> option) {
    final isSelected = widget.wizardData.gender == option['value'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.wizardData.gender = option['value'];
          });
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: isSelected ? option['color'] : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? option['color'].withOpacity(0.1) : null,
          ),
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option['color'].withOpacity(isSelected ? 1.0 : 0.2),
                ),
                child: Icon(
                  option['icon'],
                  color: isSelected ? Colors.white : option['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['label'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      option['description'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: option['color'],
                ),
            ],
          ),
        ),
      ),
    );
  }
}