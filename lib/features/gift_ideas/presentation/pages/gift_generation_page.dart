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

  // Modificato: Ora usiamo un'età specifica invece di un range
  int _selectedAge = 30; // Default

  // Aggiunto: genere con default
  String _selectedGender = 'X';

  String _selectedRelation = '';
  final List<String> _selectedInterests = [];
  String _selectedCategory = '';
  String _selectedBudget = '';

  // Opzioni per i dropdown
  // Aggiunto: opzioni genere
  final List<Map<String, String>> _genderOptions = [
    {'value': 'X', 'label': 'Non specificato'},
    {'value': 'M', 'label': 'Uomo'},
    {'value': 'F', 'label': 'Donna'},
    {'value': 'N', 'label': 'Non binario'},
    {'value': 'O', 'label': 'Altro'},
  ];

  // Modificato: età ora è un elenco di valori singoli
  final List<int> _commonAges = [18, 25, 30, 40, 50, 65];

  // Modificato: valori corretti accettati dall'API
  final List<String> _relations = [
    'amico',
    'familiare',
    'partner',
    'collega',
    'altro'
  ];

  // Relazioni in formato visualizzabile
  final Map<String, String> _relationLabels = {
    'amico': 'Amico',
    'familiare': 'Familiare',
    'partner': 'Partner',
    'collega': 'Collega',
    'altro': 'Altro',
  };

  final List<String> _interests = [
    'Musica',
    'Sport',
    'Lettura',
    'Tecnologia',
    'Cucina',
    'Viaggi',
    'Arte',
    'Moda',
    'Gaming',
    'Film'
  ];
  final List<String> _categories = [
    'Tech',
    'Casa',
    'Moda',
    'Sport',
    'Bellezza',
    'Hobby',
    'Libri',
    'Bambini'
  ];

  // Modificato: budget senza simbolo €
  final List<String> _budgets = ['0-20', '20-50', '50-100', '100-200', '200+'];

  bool _isFormComplete() {
    return _selectedGender.isNotEmpty && // Aggiunto controllo genere
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
              age: _selectedAge.toString(), // Convertito a stringa
              gender: _selectedGender, // Ora passiamo il genere selezionato
              relation: _selectedRelation, // Ora è nel formato corretto
              interests: _selectedInterests,
              category: _selectedCategory,
              budget: _selectedBudget, // Senza simbolo €
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

                    // NUOVO: Genere
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genere',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                          padding: const EdgeInsets.all(AppTheme.spaceM),
                          child: Wrap(
                            spacing: AppTheme.spaceS,
                            runSpacing: AppTheme.spaceS,
                            children: _genderOptions.map((gender) {
                              final isSelected =
                                  _selectedGender == gender['value'];
                              return ChoiceChip(
                                label: Text(gender['label']!),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedGender = gender['value']!;
                                    }
                                  });
                                },
                                backgroundColor: Colors.transparent,
                                selectedColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceL),

                    // MODIFICATO: Età specifica invece di range
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Età (approssimativa)',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spaceXS),

                        // Selettore età con +/-
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (_selectedAge > 1) {
                                  setState(() {
                                    _selectedAge--;
                                  });
                                }
                              },
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppTheme.spaceM),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusM),
                                ),
                                child: Text(
                                  _selectedAge.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  _selectedAge++;
                                });
                              },
                            ),
                          ],
                        ),

                        // Età comuni per selezione rapida
                        const SizedBox(height: AppTheme.spaceM),
                        Wrap(
                          spacing: AppTheme.spaceS,
                          children: _commonAges.map((age) {
                            return ChoiceChip(
                              label: Text(age.toString()),
                              selected: _selectedAge == age,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedAge = age;
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceL),

                    // MODIFICATO: Relazione - ora usa i valori corretti per l'API
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Relazione',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      hint: const Text('Seleziona relazione'),
                      value:
                          _selectedRelation.isEmpty ? null : _selectedRelation,
                      items: _relations.map((relation) {
                        return DropdownMenuItem<String>(
                          value: relation,
                          child: Text(_relationLabels[relation] ?? relation),
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

                    // Interessi - uguale
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interessi',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spaceXS),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                          padding: const EdgeInsets.all(AppTheme.spaceM),
                          child: Wrap(
                            spacing: AppTheme.spaceS,
                            runSpacing: AppTheme.spaceS,
                            children: _interests.map((interest) {
                              final isSelected =
                                  _selectedInterests.contains(interest);
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
                                selectedColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusM),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.3),
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

                    // Categoria - uguale
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      hint: const Text('Seleziona categoria'),
                      value:
                          _selectedCategory.isEmpty ? null : _selectedCategory,
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

                    // MODIFICATO: Budget - senza simbolo €
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Budget',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        prefixIcon: const Icon(Icons.euro_outlined),
                      ),
                      hint: const Text('Seleziona budget'),
                      value: _selectedBudget.isEmpty ? null : _selectedBudget,
                      items: _budgets.map((budget) {
                        return DropdownMenuItem<String>(
                          value: budget,
                          child: Text('$budget€'),
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