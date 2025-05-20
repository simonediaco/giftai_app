import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CategoryStep extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryStep({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryStep> createState() => _CategoryStepState();
}

class _CategoryStepState extends State<CategoryStep> {
  late String _selectedCategory;
  final TextEditingController _customCategoryController = TextEditingController();
  
  final List<CategoryOption> _categories = [
    CategoryOption(
      name: 'Tech',
      icon: Icons.devices,
      color: Colors.blue,
      description: 'Gadget, elettronica, accessori tecnologici',
    ),
    CategoryOption(
      name: 'Casa',
      icon: Icons.home,
      color: Colors.green,
      description: 'Arredamento, decorazioni, oggetti per la casa',
    ),
    CategoryOption(
      name: 'Moda',
      icon: Icons.shopping_bag,
      color: Colors.purple,
      description: 'Abbigliamento, accessori, scarpe',
    ),
    CategoryOption(
      name: 'Bellezza',
      icon: Icons.spa,
      color: Colors.pink,
      description: 'Cosmetici, profumi, prodotti per la cura personale',
    ),
    CategoryOption(
      name: 'Sport',
      icon: Icons.sports_soccer,
      color: Colors.orange,
      description: 'Attrezzatura sportiva, abbigliamento tecnico',
    ),
    CategoryOption(
      name: 'Libri',
      icon: Icons.menu_book,
      color: Colors.brown,
      description: 'Libri, ebook, audiolibri',
    ),
    CategoryOption(
      name: 'Esperienze',
      icon: Icons.card_travel,
      color: Colors.teal,
      description: 'Viaggi, corsi, attività, eventi',
    ),
    CategoryOption(
      name: 'Bambini',
      icon: Icons.child_care,
      color: Colors.amber,
      description: 'Giocattoli, abbigliamento, accessori per bambini',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    
    // Se è una categoria personalizzata, imposta il controller
    if (!_categories.any((c) => c.name.toLowerCase() == _selectedCategory.toLowerCase())) {
      _customCategoryController.text = _selectedCategory;
    }
  }
  
  @override
  void dispose() {
    _customCategoryController.dispose();
    super.dispose();
  }
  
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      widget.onCategoryChanged(category);
    });
  }
  
  void _setCustomCategory() {
    final category = _customCategoryController.text.trim();
    if (category.isNotEmpty) {
      setState(() {
        _selectedCategory = category;
        widget.onCategoryChanged(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Che tipo di regalo cerchi?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seleziona una categoria per il regalo',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Lista di categorie
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory.toLowerCase() == category.name.toLowerCase();
              
              return InkWell(
                onTap: () => _selectCategory(category.name),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category.color.withOpacity(0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? category.color
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category.icon,
                        color: category.color,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? category.color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Categoria personalizzata
          const Text(
            'Categoria personalizzata',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'custom_category',
                  controller: _customCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Specifica una categoria',
                    hintText: 'Es. Giardinaggio, Musica, ecc.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _setCustomCategory,
                icon: const Icon(Icons.check_circle),
                color: Theme.of(context).colorScheme.primary,
                tooltip: 'Imposta categoria personalizzata',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Visualizzazione categoria selezionata
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categoria selezionata',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
  final Color color;
  final String description;

  CategoryOption({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}