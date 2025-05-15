import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/gift_ideas_bloc.dart';
import '../bloc/gift_ideas_event.dart';
import '../bloc/gift_ideas_state.dart';
import '../widgets/gift_result_list.dart';

class GiftGenerationPage extends StatefulWidget {
  static const routeName = '/gift-generation';
  
  const GiftGenerationPage({Key? key}) : super(key: key);

  @override
  State<GiftGenerationPage> createState() => _GiftGenerationPageState();
}

class _GiftGenerationPageState extends State<GiftGenerationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedAge = '';
  String _selectedRelation = '';
  final List<String> _selectedInterests = [];
  String _selectedCategory = '';
  String _selectedBudget = '';
  
  // Opzioni per i dropdown
  final List<String> _ageRanges = ['0-12', '13-18', '19-30', '31-50', '51+'];
  final List<String> _relations = ['Amico', 'Parente', 'Partner', 'Collega', 'Altro'];
  final List<String> _interests = ['Musica', 'Sport', 'Lettura', 'Tecnologia', 'Cucina', 'Viaggi', 'Arte', 'Moda', 'Gaming', 'Film'];
  final List<String> _categories = ['Tech', 'Casa', 'Moda', 'Sport', 'Bellezza', 'Hobby', 'Libri', 'Bambini'];
  final List<String> _budgets = ['0-20€', '20-50€', '50-100€', '100-200€', '200€+'];

  bool _isFormComplete() {
    return _selectedAge.isNotEmpty &&
        _selectedRelation.isNotEmpty &&
        _selectedInterests.isNotEmpty &&
        _selectedCategory.isNotEmpty &&
        _selectedBudget.isNotEmpty;
  }

  void _generateGiftIdeas() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<GiftIdeasBloc>().add(
        GenerateGiftIdeasRequested(
          name: _nameController.text.trim(),
          age: _selectedAge,
          relation: _selectedRelation,
          interests: _selectedInterests,
          category: _selectedCategory,
          budget: _selectedBudget,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genera Idee Regalo'),
      ),
      body: BlocConsumer<GiftIdeasBloc, GiftIdeasState>(
        listener: (context, state) {
          if (state is GiftIdeasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GiftIdeasLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GiftIdeasGenerated) {
            // Mostra i risultati
            return GiftResultList(gifts: state.gifts);
          } else {
            // Mostra il form di generazione
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Inserisci i dettagli per la generazione',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    // Nome
                    AppTextField(
                      label: 'Nome del destinatario (opzionale)',
                      hint: 'Es. Marco',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Età
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Fascia d\'età',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.cake_outlined),
                      ),
                      hint: const Text('Seleziona fascia d\'età'),
                      value: _selectedAge.isEmpty ? null : _selectedAge,
                      items: _ageRanges.map((age) {
                        return DropdownMenuItem<String>(
                          value: age,
                          child: Text(age),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAge = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleziona una fascia d\'età';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Relazione
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Relazione',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      hint: const Text('Seleziona relazione'),
                      value: _selectedRelation.isEmpty ? null : _selectedRelation,
                      items: _relations.map((relation) {
                        return DropdownMenuItem<String>(
                          value: relation,
                          child: Text(relation),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRelation = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleziona una relazione';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Interessi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interessi',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                          padding: const EdgeInsets.all(AppTheme.spaceM),
                          child: Wrap(
                            spacing: AppTheme.spaceS,
                            runSpacing: AppTheme.spaceS,
                            children: _interests.map((interest) {
                              final isSelected = _selectedInterests.contains(interest);
                              return FilterChip(
                                label: Text(interest),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedInterests.add(interest);
                                    } else {
                                      _selectedInterests.remove(interest);
                                    }
                                  });
                                },
                                backgroundColor: Colors.transparent,
                                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                        ),
                        if (_formKey.currentState?.validate() == false &&
                            _selectedInterests.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppTheme.spaceXS,
                              left: AppTheme.spaceM,
                            ),
                            child: Text(
                              'Seleziona almeno un interesse',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Categoria
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      hint: const Text('Seleziona categoria'),
                      value: _selectedCategory.isEmpty ? null : _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleziona una categoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Budget
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Budget',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.euro_outlined),
                      ),
                      hint: const Text('Seleziona budget'),
                      value: _selectedBudget.isEmpty ? null : _selectedBudget,
                      items: _budgets.map((budget) {
                        return DropdownMenuItem<String>(
                          value: budget,
                          child: Text(budget),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBudget = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Seleziona un budget';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Pulsante di generazione
                    AppButton(
                      text: 'Genera Idee Regalo',
                      onPressed: _isFormComplete() ? _generateGiftIdeas : null,
                      isLoading: state is GiftIdeasLoading,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}