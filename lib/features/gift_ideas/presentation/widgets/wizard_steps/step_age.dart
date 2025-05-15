import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_option_card.dart';

class StepAge extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepAge({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepAge> createState() => _StepAgeState();
}

class _StepAgeState extends State<StepAge> {
  final _nameController = TextEditingController();
  final List<String> _ageRanges = ['0-12', '13-18', '19-30', '31-50', '51+'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wizardData.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo nome opzionale
          AppTextField(
            label: 'Nome (opzionale)',
            hint: 'Inserisci il nome del destinatario',
            controller: _nameController,
            prefixIcon: const Icon(Icons.person_outline),
            onChanged: (value) {
              widget.wizardData.name = value;
            },
          ),
          const SizedBox(height: AppTheme.spaceXL),

          // Titolo fascia d'età
          Text(
            'Fascia d\'età',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceM),

          // Opzioni fascia d'età
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: AppTheme.spaceM,
              mainAxisSpacing: AppTheme.spaceM,
            ),
            itemCount: _ageRanges.length,
            itemBuilder: (context, index) {
              final ageRange = _ageRanges[index];
              final isSelected = widget.wizardData.age == ageRange;

              return WizardOptionCard(
                title: ageRange,
                subtitle: _getAgeDescription(ageRange),
                icon: _getAgeIcon(ageRange),
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    widget.wizardData.age = ageRange;
                    // Salva anche il nome se è stato inserito
                    widget.wizardData.name = _nameController.text.isNotEmpty
                        ? _nameController.text
                        : null;
                  });
                },
              );
            },
          ),
          const SizedBox(height: AppTheme.spaceXL),

          // Pulsante per continuare
          Center(
            child: AppButton(
              text: 'Continua',
              icon: const Icon(Icons.arrow_forward),
              onPressed: widget.wizardData.isStepOneComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getAgeDescription(String ageRange) {
    switch (ageRange) {
      case '0-12':
        return 'Bambini';
      case '13-18':
        return 'Adolescenti';
      case '19-30':
        return 'Giovani adulti';
      case '31-50':
        return 'Adulti';
      case '51+':
        return 'Senior';
      default:
        return '';
    }
  }

  IconData _getAgeIcon(String ageRange) {
    switch (ageRange) {
      case '0-12':
        return Icons.child_care;
      case '13-18':
        return Icons.school;
      case '19-30':
        return Icons.face;
      case '31-50':
        return Icons.person;
      case '51+':
        return Icons.elderly;
      default:
        return Icons.person;
    }
  }
}