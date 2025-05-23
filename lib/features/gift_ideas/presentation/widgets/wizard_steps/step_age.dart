// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_age.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

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

class _StepAgeState extends State<StepAge> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  int _selectedAge = 30;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wizardData.name ?? '';
    _selectedAge = widget.wizardData.age ?? 30;
    widget.wizardData.age = _selectedAge;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _changeAge(int delta) {
    final newAge = _selectedAge + delta;
    if (newAge >= 1 && newAge <= 120) {
      setState(() {
        _selectedAge = newAge;
        widget.wizardData.age = newAge;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
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
                  // Campo nome ottimizzato
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.05),
                          theme.colorScheme.secondary.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXL),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spaceM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nome del destinatario',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Opzionale, ma aiuta a personalizzare',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spaceM),
                        TextFormField(
                          controller: _nameController,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Es. Marco, Giulia, Papà, La mia amica...',
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                            filled: true,
                            fillColor: theme.scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceL,
                              vertical: AppTheme.spaceM,
                            ),
                          ),
                          onChanged: (value) {
                            widget.wizardData.name = value.isNotEmpty ? value : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Sezione età
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Seleziona l\'età',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceXL),
                        
                        // Display età principale
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Cerchio decorativo di sfondo
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            
                            // Cerchio principale con età
                            AnimatedBuilder(
                              animation: _scaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.secondary,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _selectedAge.toString(),
                                            style: const TextStyle(
                                              fontSize: 56,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          const Text(
                                            'anni',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spaceXL),
                        
                        // Controlli età
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton(
                              icon: Icons.remove,
                              onPressed: () => _changeAge(-1),
                              onLongPress: () => _changeAge(-10),
                            ),
                            const SizedBox(width: AppTheme.spaceXXL),
                            _buildControlButton(
                              icon: Icons.add,
                              onPressed: () => _changeAge(1),
                              onLongPress: () => _changeAge(10),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spaceM),
                        Text(
                          'Tieni premuto per ±10',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spaceXL),
                        
                        // Età suggerite
                        Column(
                          children: [
                            Text(
                              'Età comuni',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spaceM),
                            Wrap(
                              spacing: AppTheme.spaceM,
                              runSpacing: AppTheme.spaceM,
                              children: [18, 30, 40, 55].map((age) {
                                final isSelected = _selectedAge == age;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedAge = age;
                                      widget.wizardData.age = age;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                      border: Border.all(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.outline.withOpacity(0.3),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected ? [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ] : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        age.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
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
  
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required VoidCallback onLongPress,
  }) {
    final theme = Theme.of(context);
    
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}