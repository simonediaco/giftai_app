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
      icon: Icons.group,
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
    ),
    RelationOption(
      value: 'partner',
      title: 'Partner',
      icon: Icons.favorite,
      gradient: [Colors.red.shade400, Colors.red.shade600],
    ),
    RelationOption(
      value: 'familiare',
      title: 'Familiare',
      icon: Icons.home,
      gradient: [Colors.green.shade400, Colors.green.shade600],
    ),
    RelationOption(
      value: 'collega',
      title: 'Collega',
      icon: Icons.work,
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
    ),
    RelationOption(
      value: 'altro',
      title: 'Altro',
      icon: Icons.edit,
      gradient: [Colors.purple.shade400, Colors.purple.shade600],
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedRelation = widget.wizardData.relation;
    
    // Controlla se è una relazione custom
    if (_selectedRelation != null && 
        !['amico', 'partner', 'familiare', 'collega'].contains(_selectedRelation)) {
      _showCustomField = true;
      _customRelationController.text = _selectedRelation!;
      _selectedRelation = 'altro';
    }
  }
  
  @override
  void dispose() {
    _customRelationController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    if (_showCustomField) {
      return _customRelationController.text.trim().isNotEmpty;
    }
    return _selectedRelation != null && _selectedRelation != 'altro';
  }

  void _handleRelationTap(String value) {
    setState(() {
      _selectedRelation = value;
      _showCustomField = value == 'altro';
      
      if (value == 'altro') {
        widget.wizardData.relation = null;
      } else {
        widget.wizardData.relation = value;
        _customRelationController.clear();
      }
    });
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lista opzioni verticale più semplice
                  ...List.generate(_relationOptions.length, (index) {
                    final option = _relationOptions[index];
                    final isSelected = _selectedRelation == option.value;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                      child: _RelationTile(
                        option: option,
                        isSelected: isSelected,
                        onTap: () => _handleRelationTap(option.value),
                      ),
                    );
                  }),
                  
                  // Campo personalizzato
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _showCustomField ? null : 0,
                    child: _showCustomField
                        ? Container(
                            margin: const EdgeInsets.only(top: AppTheme.spaceM),
                            padding: const EdgeInsets.all(AppTheme.spaceL),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0.05),
                                  theme.colorScheme.secondary.withOpacity(0.03),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Specifica la relazione',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spaceM),
                                TextFormField(
                                  controller: _customRelationController,
                                  autofocus: true,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: 'Es. insegnante, vicino di casa, cognato...',
                                    filled: true,
                                    fillColor: theme.scaffoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.wizardData.relation = value.trim().isNotEmpty ? value.trim() : null;
                                    });
                                  },
                                  onFieldSubmitted: (_) {
                                    if (_canContinue) {
                                      widget.onComplete();
                                    }
                                  },
                                ),
                              ],
                            ),
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
            isEnabled: _canContinue,
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
  final List<Color> gradient;
  
  RelationOption({
    required this.value,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}

class _RelationTile extends StatelessWidget {
  final RelationOption option;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _RelationTile({
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppTheme.spaceL),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: option.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: isSelected
                  ? option.gradient.last
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? option.gradient.first.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : option.gradient.first.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  color: isSelected ? Colors.white : option.gradient.first,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spaceL),
              Expanded(
                child: Text(
                  option.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}