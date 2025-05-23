// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_gender_enhanced.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepGenderEnhanced extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepGenderEnhanced({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepGenderEnhanced> createState() => _StepGenderEnhancedState();
}

class _StepGenderEnhancedState extends State<StepGenderEnhanced> {
  final List<GenderOption> _genderOptions = [
    GenderOption(
      value: 'M',
      label: 'Uomo',
      icon: Icons.male,
      color: const Color(0xFF1976D2),
      gradient: const [Color(0xFF1976D2), Color(0xFF1565C0)],
    ),
    GenderOption(
      value: 'F',
      label: 'Donna',
      icon: Icons.female,
      color: const Color(0xFFE91E63),
      gradient: const [Color(0xFFE91E63), Color(0xFFC2185B)],
    ),
    GenderOption(
      value: 'N',
      label: 'Non binario',
      icon: Icons.transgender,
      color: const Color(0xFF9C27B0),
      gradient: const [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
    ),
    GenderOption(
      value: 'X',
      label: 'Non specificato',
      icon: Icons.person,
      color: const Color(0xFF607D8B),
      gradient: const [Color(0xFF607D8B), Color(0xFF455A64)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spaceL),
                  
                  // Grid 2x2 per le opzioni
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: AppTheme.spaceM,
                      mainAxisSpacing: AppTheme.spaceM,
                    ),
                    itemCount: _genderOptions.length,
                    itemBuilder: (context, index) {
                      final option = _genderOptions[index];
                      final isSelected = widget.wizardData.gender == option.value;
                      
                      return _GenderCard(
                        option: option,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            widget.wizardData.gender = option.value;
                          });
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Info privacy
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppTheme.spaceM),
                        Expanded(
                          child: Text(
                            'Questa informazione ci aiuta a suggerire regali più appropriati',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: true,
          ),
        ],
      ),
    );
  }
}

class GenderOption {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  
  const GenderOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class _GenderCard extends StatelessWidget {
  final GenderOption option;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _GenderCard({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: option.gradient,
                  )
                : null,
            color: isSelected ? null : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXL),
            border: Border.all(
              color: isSelected
                  ? option.color
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: option.color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icona con cerchio di sfondo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : option.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option.icon,
                    size: 36,
                    color: isSelected ? Colors.white : option.color,
                  ),
                ),
                
                const SizedBox(height: AppTheme.spaceM),
                
                // Label
                Text(
                  option.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                
                // Indicatore di selezione
                const SizedBox(height: AppTheme.spaceS),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 40 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}