// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_interests_enhanced.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepInterestsEnhanced extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepInterestsEnhanced({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepInterestsEnhanced> createState() => _StepInterestsEnhancedState();
}

class _StepInterestsEnhancedState extends State<StepInterestsEnhanced> {
  final _customInterestController = TextEditingController();
  bool _showAddField = false;
  
  final List<InterestOption> _predefinedInterests = [
    InterestOption(name: 'Musica', icon: Icons.music_note, color: Colors.purple),
    InterestOption(name: 'Sport', icon: Icons.sports_soccer, color: Colors.green),
    InterestOption(name: 'Tecnologia', icon: Icons.computer, color: Colors.blue),
    InterestOption(name: 'Libri', icon: Icons.book, color: Colors.brown),
    InterestOption(name: 'Cucina', icon: Icons.restaurant, color: Colors.orange),
    InterestOption(name: 'Arte', icon: Icons.palette, color: Colors.red),
    InterestOption(name: 'Viaggi', icon: Icons.flight, color: Colors.lightBlue),
    InterestOption(name: 'Film', icon: Icons.movie, color: Colors.indigo),
    InterestOption(name: 'Gaming', icon: Icons.games, color: Colors.deepPurple),
    InterestOption(name: 'Fotografia', icon: Icons.camera_alt, color: Colors.teal),
    InterestOption(name: 'Fitness', icon: Icons.fitness_center, color: Colors.deepOrange),
    InterestOption(name: 'Moda', icon: Icons.shopping_bag, color: Colors.pink),
  ];
  
  List<String> _customInterests = [];
  
  @override
  void initState() {
    super.initState();
    // Separa interessi predefiniti da quelli custom
    for (String interest in widget.wizardData.interests) {
      if (!_predefinedInterests.any((option) => option.name == interest)) {
        _customInterests.add(interest);
      }
    }
  }
  
  void _addCustomInterest() {
    final interest = _customInterestController.text.trim();
    if (interest.isNotEmpty && !widget.wizardData.interests.contains(interest)) {
      setState(() {
        final updatedInterests = List<String>.from(widget.wizardData.interests);
        updatedInterests.add(interest);
        widget.wizardData.interests = updatedInterests;
        _customInterests.add(interest);
        _customInterestController.clear();
        _showAddField = false;
      });
    }
  }
  
  @override
  void dispose() {
    _customInterestController.dispose();
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
                  // Header con contatore
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceM,
                      vertical: AppTheme.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spaceS),
                        Text(
                          '${widget.wizardData.interests.length} interessi selezionati',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spaceL),
                  
                  // Grid interessi predefiniti
                  Text(
                    'Interessi principali',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: AppTheme.spaceM,
                      mainAxisSpacing: AppTheme.spaceM,
                    ),
                    itemCount: _predefinedInterests.length,
                    itemBuilder: (context, index) {
                      final interest = _predefinedInterests[index];
                      final isSelected = widget.wizardData.interests.contains(interest.name);
                      
                      return _InterestChip(
                        interest: interest,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            final updatedInterests = List<String>.from(widget.wizardData.interests);
                            if (isSelected) {
                              updatedInterests.remove(interest.name);
                            } else {
                              updatedInterests.add(interest.name);
                            }
                            widget.wizardData.interests = updatedInterests;
                          });
                        },
                      );
                    },
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Sezione interessi personalizzati
                  Row(
                    children: [
                      Text(
                        'Altri interessi',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showAddField = !_showAddField;
                          });
                        },
                        icon: Icon(
                          _showAddField ? Icons.close : Icons.add_circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  // Campo per aggiungere interesse
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showAddField ? null : 0,
                    child: _showAddField
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppTheme.spaceM),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _customInterestController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: 'Es. Giardinaggio, Yoga, Astronomia...',
                                      filled: true,
                                      fillColor: theme.colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.add,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    onFieldSubmitted: (_) => _addCustomInterest(),
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spaceM),
                                IconButton(
                                  onPressed: _addCustomInterest,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  
                  // Lista interessi custom
                  if (_customInterests.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spaceM),
                    Wrap(
                      spacing: AppTheme.spaceS,
                      runSpacing: AppTheme.spaceS,
                      children: _customInterests.map((interest) {
                        return Chip(
                          label: Text(interest),
                          onDeleted: () {
                            setState(() {
                              final updatedInterests = List<String>.from(widget.wizardData.interests);
                              updatedInterests.remove(interest);
                              widget.wizardData.interests = updatedInterests;
                              _customInterests.remove(interest);
                            });
                          },
                          backgroundColor: GoldenAccents.light.withOpacity(0.3),
                          deleteIconColor: theme.colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Bottone continua
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: widget.wizardData.interests.isNotEmpty,
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

class _InterestChip extends StatelessWidget {
  final InterestOption interest;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _InterestChip({
    Key? key,
    required this.interest,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? interest.color.withOpacity(0.2) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
          border: Border.all(
            color: isSelected ? interest.color : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              interest.icon,
              color: isSelected ? interest.color : theme.colorScheme.onSurface.withOpacity(0.5),
              size: 28,
            ),
            const SizedBox(height: AppTheme.spaceS),
            Text(
              interest.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? interest.color : theme.colorScheme.onSurface,
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