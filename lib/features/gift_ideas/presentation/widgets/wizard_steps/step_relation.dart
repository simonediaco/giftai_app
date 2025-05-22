import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_option_card.dart';

class StepRelation extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepRelation({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepRelation> createState() => _StepRelationState();
}

class _StepRelationState extends State<StepRelation> {
  final List<RelationOption> _relationOptions = [
    RelationOption(
      title: 'Amico', //TODO: translate 
      icon: Icons.people_outline,
      description: 'Un amico o conoscente',
    ),
    RelationOption(
      title: 'Partner',
      icon: Icons.favorite_border,
      description: 'Partner o coniuge',
    ),
    RelationOption(
      title: 'Familiare',
      icon: Icons.family_restroom,
      description: 'Genitore, figlio, parente',
    ),
    RelationOption(
      title: 'Collega',
      icon: Icons.work_outline,
      description: 'Collega di lavoro',
    ),
    RelationOption(
      title: 'Insegnante',
      icon: Icons.school_outlined,
      description: 'Mentore o educatore',
    ),
    RelationOption(
      title: 'Altro',
      icon: Icons.person_outline,
      description: 'Altra relazione',
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
            'Che tipo di relazione hai con questa persona?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spaceL),
          
          // Opzioni di relazione
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: AppTheme.spaceM,
              mainAxisSpacing: AppTheme.spaceM,
            ),
            itemCount: _relationOptions.length,
            itemBuilder: (context, index) {
              final option = _relationOptions[index];
              final isSelected = widget.wizardData.relation == option.title;
              
              return WizardOptionCard(
                title: option.title,
                subtitle: option.description,
                icon: option.icon,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    widget.wizardData.relation = option.title;
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
              onPressed: widget.wizardData.isStepTwoComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class RelationOption {
  final String title;
  final IconData icon;
  final String description;
  
  RelationOption({
    required this.title,
    required this.icon,
    required this.description,
  });
}