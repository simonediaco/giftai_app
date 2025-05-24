// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_category_enhanced.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';
import '../../models/gift_wizard_data.dart';
import '../wizard_continue_button.dart';

class StepCategoryEnhanced extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepCategoryEnhanced({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepCategoryEnhanced> createState() => _StepCategoryEnhancedState();
}

class _StepCategoryEnhancedState extends State<StepCategoryEnhanced> {
  final List<CategoryOption> _categories = [
    CategoryOption(
      name: 'Tech',
      icon: Icons.devices_other,
      description: 'Gadget, elettronica e accessori tech',
      gradient: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
    ),
    CategoryOption(
      name: 'Casa',
      icon: Icons.home_filled,
      description: 'Decorazioni, utensili e comfort',
      gradient: [const Color(0xFF4CAF50), const Color(0xFF388E3C)],
    ),
    CategoryOption(
      name: 'Moda',
      icon: Icons.shopping_bag,
      description: 'Abbigliamento, scarpe e accessori',
      gradient: [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)],
    ),
    CategoryOption(
      name: 'Sport',
      icon: Icons.sports_tennis,
      description: 'Attrezzature sportive e fitness',
      gradient: [const Color(0xFFFF5722), const Color(0xFFE64A19)],
    ),
    CategoryOption(
      name: 'Bellezza',
      icon: Icons.spa,
      description: 'Cosmetici, profumi e benessere',
      gradient: [const Color(0xFFE91E63), const Color(0xFFC2185B)],
    ),
    CategoryOption(
      name: 'Libri',
      icon: Icons.menu_book,
      description: 'Romanzi, saggi e fumetti',
      gradient: [const Color(0xFF795548), const Color(0xFF5D4037)],
    ),
    CategoryOption(
      name: 'Hobby',
      icon: Icons.palette,
      description: 'Arte, musica e creatività',
      gradient: [const Color(0xFF00BCD4), const Color(0xFF0097A7)],
    ),
    CategoryOption(
      name: 'Esperienze',
      icon: Icons.confirmation_number,
      description: 'Viaggi, corsi e attività',
      gradient: [const Color(0xFFFF9800), const Color(0xFFF57C00)],
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Suggerimento basato su interessi
                  if (widget.wizardData.interests.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spaceL),
                      padding: const EdgeInsets.all(AppTheme.spaceM),
                      decoration: BoxDecoration(
                        color: GoldenAccents.light.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                        border: Border.all(
                          color: GoldenAccents.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: GoldenAccents.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spaceM),
                          Expanded(
                            child: Text(
                              _getSuggestionText(),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Lista categorie verticale
                  ...List.generate(_categories.length, (index) {
                    final category = _categories[index];
                    final isSelected = widget.wizardData.category == category.name;
                    final isRecommended = _isRecommendedCategory(category.name);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                      child: _CategoryTile(
                        category: category,
                        isSelected: isSelected,
                        isRecommended: isRecommended,
                        onTap: () {
                          setState(() {
                            widget.wizardData.category = category.name;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          WizardContinueButton(
            onPressed: widget.onComplete,
            isEnabled: widget.wizardData.category != null,
          ),
        ],
      ),
    );
  }
  
  String _getSuggestionText() {
    final interests = widget.wizardData.interests;
    if (interests.any((i) => ['Tecnologia', 'Gaming'].contains(i))) {
      return '💡 Ti suggeriamo Tech per gli appassionati di tecnologia';
    } else if (interests.any((i) => ['Sport', 'Fitness'].contains(i))) {
      return '💡 Sport sembra perfetto per questi interessi';
    } else if (interests.contains('Libri')) {
      return '💡 Libri è sempre una scelta vincente per chi ama leggere';
    }
    return '💡 Scegli la categoria che ti ispira di più';
  }
  
  bool _isRecommendedCategory(String categoryName) {
    final interests = widget.wizardData.interests;
    switch (categoryName) {
      case 'Tech':
        return interests.any((i) => ['Tecnologia', 'Gaming', 'Fotografia'].contains(i));
      case 'Sport':
        return interests.any((i) => ['Sport', 'Fitness'].contains(i));
      case 'Libri':
        return interests.contains('Libri');
      case 'Casa':
        return interests.contains('Cucina');
      case 'Hobby':
        return interests.any((i) => ['Arte', 'Musica'].contains(i));
      case 'Esperienze':
        return interests.contains('Viaggi');
      default:
        return false;
    }
  }
}

class CategoryOption {
  final String name;
  final IconData icon;
  final String description;
  final List<Color> gradient;
  
  const CategoryOption({
    required this.name,
    required this.icon,
    required this.description,
    required this.gradient,
  });
}

class _CategoryTile extends StatelessWidget {
  final CategoryOption category;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;
  
  const _CategoryTile({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.isRecommended,
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
                    colors: category.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: isSelected
                  ? category.gradient.last
                  : isRecommended
                      ? GoldenAccents.primary.withOpacity(0.5)
                      : theme.colorScheme.outline.withOpacity(0.3),
              width: isSelected || isRecommended ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? category.gradient.first.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : category.gradient.first.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: isSelected ? Colors.white : category.gradient.first,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppTheme.spaceL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isRecommended && !isSelected) ...[
                          const SizedBox(width: AppTheme.spaceS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: GoldenAccents.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Consigliato',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white.withOpacity(0.9)
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
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