import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../models/gift_wizard_data.dart';
import '../interest_tag.dart';

class StepInterests extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepInterests({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepInterests> createState() => _StepInterestsState();
}

class _StepInterestsState extends State<StepInterests> {
  final List<InterestOption> _interestOptions = [
    InterestOption(
      name: 'Musica',
      icon: Icons.music_note,
      color: Colors.purple,
    ),
    InterestOption(
      name: 'Sport',
      icon: Icons.sports_soccer,
      color: Colors.green,
    ),
    InterestOption(
      name: 'Tecnologia',
      icon: Icons.computer,
      color: Colors.blue,
    ),
    InterestOption(
      name: 'Libri',
      icon: Icons.book,
      color: Colors.brown,
    ),
    InterestOption(
      name: 'Cucina',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    InterestOption(
      name: 'Arte',
      icon: Icons.palette,
      color: Colors.red,
    ),
    InterestOption(
      name: 'Viaggi',
      icon: Icons.flight,
      color: Colors.lightBlue,
    ),
    InterestOption(
      name: 'Film',
      icon: Icons.movie,
      color: Colors.indigo,
    ),
    InterestOption(
      name: 'Gaming',
      icon: Icons.games,
      color: Colors.deepPurple,
    ),
    InterestOption(
      name: 'Fotografia',
      icon: Icons.camera_alt,
      color: Colors.teal,
    ),
    InterestOption(
      name: 'Fitness',
      icon: Icons.fitness_center,
      color: Colors.deepOrange,
    ),
    InterestOption(
      name: 'Moda',
      icon: Icons.shopping_bag,
      color: Colors.pink,
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
            'Seleziona gli interessi che descrivono meglio questa persona (almeno 1)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spaceM),
          
          // Contatore interessi selezionati
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spaceS,
              horizontal: AppTheme.spaceM,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            ),
            child: Text(
              'Selezionati: ${widget.wizardData.interests.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceL),
          
          // Grid di interessi
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppTheme.spaceM,
              mainAxisSpacing: AppTheme.spaceM,
            ),
            itemCount: _interestOptions.length,
            itemBuilder: (context, index) {
              final interest = _interestOptions[index];
              final isSelected = widget.wizardData.interests.contains(interest.name);
              
              return InterestTag(
                title: interest.name,
                icon: interest.icon,
                color: interest.color,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      widget.wizardData.interests.remove(interest.name);
                    } else {
                      widget.wizardData.interests.add(interest.name);
                    }
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
              onPressed: widget.wizardData.isStepThreeComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class InterestOption {
  final String name;
  final IconData icon;
  final Color color;
  
  InterestOption({
    required this.name,
    required this.icon,
    required this.color,
  });
}