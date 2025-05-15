import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../models/gift_wizard_data.dart';
import '../category_card.dart';

class StepCategory extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepCategory({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepCategory> createState() => _StepCategoryState();
}

class _StepCategoryState extends State<StepCategory> {
  final List<CategoryOption> _categoryOptions = [
    CategoryOption(
      name: 'Tech',
      icon: Icons.devices,
      description: 'Gadget, elettronica e accessori tech',
      color: Colors.blue,
    ),
    CategoryOption(
      name: 'Casa',
      icon: Icons.home,
      description: 'Arredamento e decorazioni per la casa',
      color: Colors.green,
    ),
    CategoryOption(
      name: 'Moda',
      icon: Icons.shopping_bag,
      description: 'Abbigliamento e accessori alla moda',
      color: Colors.purple,
    ),
    CategoryOption(
      name: 'Sport',
      icon: Icons.sports_soccer,
      description: 'Attrezzature e abbigliamento sportivo',
      color: Colors.orange,
    ),
    CategoryOption(
      name: 'Bellezza',
      icon: Icons.spa,
      description: 'Prodotti di bellezza e benessere',
      color: Colors.pink,
    ),
    CategoryOption(
      name: 'Hobby',
      icon: Icons.palette,
      description: 'Articoli per hobby e tempo libero',
      color: Colors.teal,
    ),
    CategoryOption(
      name: 'Libri',
      icon: Icons.book,
      description: 'Libri, e-book e audiolibri',
      color: Colors.brown,
    ),
    CategoryOption(
      name: 'Bambini',
      icon: Icons.child_care,
      description: 'Giocattoli e articoli per bambini',
      color: Colors.red,
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
            'Scegli una categoria di regali',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spaceL),
          
          // Grid delle categorie
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: AppTheme.spaceM,
              mainAxisSpacing: AppTheme.spaceM,
            ),
            itemCount: _categoryOptions.length,
            itemBuilder: (context, index) {
              final category = _categoryOptions[index];
              final isSelected = widget.wizardData.category == category.name;
              
              return CategoryCard(
                title: category.name,
                description: category.description,
                icon: category.icon,
                color: category.color,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    widget.wizardData.category = category.name;
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
              onPressed: widget.wizardData.isStepFourComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryOption {
  final String name;
  final IconData icon;
  final String description;
  final Color color;
  
  CategoryOption({
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
  });
}