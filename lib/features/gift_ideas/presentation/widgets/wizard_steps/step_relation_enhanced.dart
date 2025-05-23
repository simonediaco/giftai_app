// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_relation_enhanced.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepRelationEnhanced extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepRelationEnhanced({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepRelationEnhanced> createState() => _StepRelationEnhancedState();
}

class _StepRelationEnhancedState extends State<StepRelationEnhanced> {
  String? _selectedRelation;
  final _customRelationController = TextEditingController();
  bool _showCustomField = false;
  
  final List<RelationOption> _relationOptions = [
    RelationOption(
      value: 'amico',
      title: 'Amico/a',
      icon: Icons.people_outline,
      description: 'Un amico o amica',
      color: Colors.blue,
    ),
    RelationOption(
      value: 'partner',
      title: 'Partner',
      icon: Icons.favorite_border,
      description: 'Fidanzato/a, marito/moglie',
      color: Colors.red,
    ),
    RelationOption(
      value: 'fratello',
      title: 'Fratello/Sorella',
      icon: Icons.family_restroom,
      description: 'Fratello, sorella, familiare',
      color: Colors.green,
    ),
    RelationOption(
      value: 'conoscente',
      title: 'Conoscente',
      icon: Icons.people_outline,
      description: 'Un conoscente',
      color: Colors.orange,
    ),
    RelationOption(
      value: 'collega',
      title: 'Collega',
      icon: Icons.work_outline,
      description: 'Collega di lavoro',
      color: Colors.pinkAccent,
    ),
    RelationOption(
      value: 'altro',
      title: 'Altro',
      icon: Icons.edit,
      description: 'Specifica la relazione',
      color: Colors.purple,
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedRelation = widget.wizardData.relation;
    if (_selectedRelation == 'altro' || 
        (_selectedRelation != null && !_isStandardRelation(_selectedRelation!))) {
      _showCustomField = true;
      _customRelationController.text = widget.wizardData.relation ?? '';
    }
  }
  
  bool _isStandardRelation(String relation) {
    return ['amico', 'partner', 'familiare', 'collega'].contains(relation);
  }
  
  @override
  void dispose() {
    _customRelationController.dispose();
    super.dispose();
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid delle relazioni
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: AppTheme.spaceM,
                      mainAxisSpacing: AppTheme.spaceM,
                    ),
                    itemCount: _relationOptions.length,
                    itemBuilder: (context, index) {
                      final option = _relationOptions[index];
                      final isSelected = _selectedRelation == option.value ||
                          (option.value == 'altro' && _showCustomField);
                      
                      return _RelationCard(
                        option: option,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedRelation = option.value;
                            _showCustomField = option.value == 'altro';
                            
                            if (option.value == 'altro') {
                              widget.wizardData.relation = null;
                            } else {
                              widget.wizardData.relation = option.value;
                              _customRelationController.clear();
                            }
                          });
                        },
                      );
                    },
                  ),
                  
                  // Campo personalizzato
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showCustomField ? null : 0,
                    child: _showCustomField
                        ? Column(
                            children: [
                              const SizedBox(height: AppTheme.spaceL),
                              Container(
                                padding: const EdgeInsets.all(AppTheme.spaceL),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: AppTheme.spaceM),
                                        Text(
                                          'Specifica la relazione',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppTheme.spaceM),
                                    TextFormField(
                                      controller: _customRelationController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Es. insegnante, vicino di casa, medico...',
                                        filled: true,
                                        fillColor: theme.scaffoldBackgroundColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        widget.wizardData.relation = value.isNotEmpty ? value : null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottone continua
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: widget.wizardData.isStepThreeComplete || 
                       (_showCustomField && _customRelationController.text.isNotEmpty),
          ),
        ],
      ),
    );
  }
}

class RelationOption {
  final String value;
  final String title;
  final IconData icon;
  final String description;
  final Color color;
  
  RelationOption({
    required this.value,
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
  });
}

class _RelationCard extends StatelessWidget {
  final RelationOption option;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _RelationCard({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? option.color.withOpacity(0.1) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
          border: Border.all(
            color: isSelected ? option.color : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? option.color : option.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                option.icon,
                color: isSelected ? Colors.white : option.color,
                size: 24,
              ),
            ),
            const SizedBox(height: AppTheme.spaceS),
            Text(
              option.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? option.color : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              option.description,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}