import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../blocs/gift/gift_bloc.dart';
import '../../blocs/gift/gift_event.dart';
import '../../blocs/gift/gift_state.dart';
import '../../models/recipient_model.dart';
import '../../utils/translations.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gift_card.dart';
import '../../widgets/loading_indicator.dart';

/// Schermata wizard per la generazione guidata di regali
class GiftGenerationWizard extends StatefulWidget {
  final Recipient? recipient;

  const GiftGenerationWizard({
    Key? key,
    this.recipient,
  }) : super(key: key);

  @override
  State<GiftGenerationWizard> createState() => _GiftGenerationWizardState();
}

class _GiftGenerationWizardState extends State<GiftGenerationWizard> {
  // Controller per lo stepper
  final PageController _pageController = PageController();
  
  // Indice pagina corrente
  int _currentPage = 0;
  
  // Dati del form
  final Map<String, dynamic> _formData = {};
  
  // Key per il form
  final _formKey = GlobalKey<FormBuilderState>();
  
  // Lista di interessi
  final List<String> _interests = [];
  
  // Controller per il campo interessi
  final TextEditingController _interestsController = TextEditingController();
  
  // Lista di opzioni per i form
  final List<String> _relationOptions = RelationshipTranslations.getAllUiValues();
  final List<String> _categoryOptions = CategoryTranslations.getAllUiValues();
  final List<String> _budgetOptions = BudgetTranslations.getAllUiValues();
  final List<String> _genderOptions = GenderTranslations.getAllUiValues();

  @override
  void initState() {
    super.initState();
    
    // Se c'è un recipient, precompiliamo i campi
    if (widget.recipient != null) {
      _formData['name'] = widget.recipient!.name;
      _formData['gender'] = widget.recipient!.gender;
      _formData['age'] = widget.recipient!.age;
      _formData['relation'] = widget.recipient!.relation;
      _interests.addAll(widget.recipient!.interests);
      _updateInterestsText();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _interestsController.dispose();
    super.dispose();
  }
  
  // Aggiorna il testo del controller con gli interessi attuali
  void _updateInterestsText() {
    _interestsController.text = _interests.join(', ');
  }

  // Aggiunge un interesse alla lista
  void _addInterest(String interest) {
    if (interest.trim().isNotEmpty && !_interests.contains(interest.trim())) {
      setState(() {
        _interests.add(interest.trim());
        _updateInterestsText();
      });
    }
  }

  // Rimuove un interesse dalla lista
  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
      _updateInterestsText();
    });
  }
  
  // Genera idee regalo basate sui dati del form
  void _generateGiftIdeas() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = _formKey.currentState!.value;
      
      // Verifica che ci siano interessi
      if (_interests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aggiungi almeno un interesse')),
        );
        return;
      }
      
      // Salva i dati del form
      _formData.addAll(formValues);

      // Genera idee per un recipient esistente o crea un nuovo form per generazione rapida
      if (widget.recipient != null) {
        context.read<GiftBloc>().add(
          GenerateGiftIdeasForRecipientEvent(
            recipientId: widget.recipient!.id!,
            category: _formData['category'] as String,
            budget: _formData['budget'] as String,
          ),
        );
      } else {
        context.read<GiftBloc>().add(
          GenerateGiftIdeasEvent(
            name: _formData['name'] as String?,
            age: _formData['age'] != null ? _formData['age'].toString() : null,
            gender: _formData['gender'] as String?,
            relation: _formData['relation'] as String,
            interests: _interests,
            category: _formData['category'] as String,
            budget: _formData['budget'] as String,
          ),
        );
      }
      
      // Passa alla pagina dei risultati
      _goToPage(4);
    }
  }
  
  // Va alla pagina specificata
  void _goToPage(int page) {
    if (page >= 0 && page <= 4) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // Passa alla pagina successiva
  void _nextPage() {
    // Salva i dati del form prima di procedere
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      _formData.addAll(values);
      
      if (_currentPage < 4) {
        _goToPage(_currentPage + 1);
      }
    }
  }
  
  // Torna alla pagina precedente
  void _previousPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurazione Regalo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Pulsante per saltare alla generazione
          if (_currentPage < 4)
            TextButton.icon(
              onPressed: _generateGiftIdeas,
              icon: const Icon(Icons.skip_next),
              label: const Text('Salta'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Indicatore di progresso
          LinearProgressIndicator(
            value: (_currentPage + 1) / 5,
            minHeight: 6,
          ),
          
          // Contenuto delle pagine
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildPersonInfoPage(),
                _buildRelationPage(),
                _buildInterestsPage(),
                _buildGiftPreferencesPage(),
                _buildResultsPage(),
              ],
            ),
          ),
          
          // Pulsanti di navigazione (solo nelle prime 4 pagine)
          if (_currentPage < 4)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pulsante indietro (non presente nella prima pagina)
                  if (_currentPage > 0)
                    OutlinedButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Indietro'),
                    )
                  else
                    const SizedBox.shrink(),
                    
                  // Pulsante avanti o fine
                  ElevatedButton.icon(
                    onPressed: _currentPage < 3 ? _nextPage : _generateGiftIdeas,
                    icon: Icon(_currentPage < 3 ? Icons.arrow_forward : Icons.auto_awesome),
                    label: Text(_currentPage < 3 ? 'Avanti' : 'Genera Idee Regalo'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  // Costruisce la pagina delle informazioni personali
  Widget _buildPersonInfoPage() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'name': _formData['name'],
        'age': _formData['age'],
        'gender': _formData['gender'],
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi riceverà il regalo?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Inserisci alcune informazioni sulla persona che riceverà il regalo',
              style: Theme.of(context).textTheme.bodyMedium,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Nome
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Nome (opzionale)',
                prefixIcon: Icon(Icons.person),
                hintText: 'Ad esempio: Marco, Anna...',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 2) {
                  return 'Il nome deve avere almeno 2 caratteri';
                }
                return null;
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 300.ms),
            
            const SizedBox(height: 24),
            
            // Età
            FormBuilderTextField(
              name: 'age',
              decoration: const InputDecoration(
                labelText: 'Età (opzionale)',
                prefixIcon: Icon(Icons.cake),
                hintText: 'Inserisci l\'età',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Inserisci un numero valido';
                  }
                  if (age < 0 || age > 120) {
                    return 'Inserisci un\'età valida (0-120)';
                  }
                }
                return null;
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 400.ms),
            
            const SizedBox(height: 24),
            
            // Genere
            FormBuilderDropdown<String>(
              name: 'gender',
              decoration: const InputDecoration(
                labelText: 'Genere (opzionale)',
                prefixIcon: Icon(Icons.people),
                hintText: 'Seleziona un genere',
              ),
              items: _genderOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 500.ms),
            
            const SizedBox(height: 24),
            
            // Suggerimento
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Più informazioni ci fornisci, più personalizzato sarà il regalo. Questi dati vengono utilizzati solo per generare suggerimenti e non sono condivisi.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }
  
  // Costruisce la pagina della relazione
  Widget _buildRelationPage() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'relation': _formData['relation'],
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Che tipo di relazione hai?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Seleziona il tipo di relazione con la persona che riceverà il regalo',
              style: Theme.of(context).textTheme.bodyMedium,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Relazione
            FormBuilderDropdown<String>(
              name: 'relation',
              decoration: const InputDecoration(
                labelText: 'Relazione*',
                prefixIcon: Icon(Icons.connect_without_contact),
                hintText: 'Seleziona una relazione',
              ),
              initialValue: _formData['relation'] ?? _relationOptions.first,
              items: _relationOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Seleziona una relazione';
                }
                return null;
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 300.ms),
            
            const SizedBox(height: 36),
            
            // Card informative per ogni tipo di relazione
            _buildRelationshipCards(),
          ],
        ),
      ),
    );
  }
  
  // Costruisce le card informative per i tipi di relazione
  Widget _buildRelationshipCards() {
    final cardData = [
      {
        'icon': Icons.favorite,
        'title': 'Partner',
        'description': 'Regali intimi, esperienze condivise, oggetti personalizzati e romantici.',
      },
      {
        'icon': Icons.people,
        'title': 'Amico',
        'description': 'Regali basati su hobby condivisi, esperienze divertenti e interessi comuni.',
      },
      {
        'icon': Icons.family_restroom,
        'title': 'Familiare',
        'description': 'Regali che rafforzano i legami familiari, oggetti significativi e utili.',
      },
      {
        'icon': Icons.work,
        'title': 'Collega',
        'description': 'Regali professionali, utili per il lavoro e appropriati per l\'ambiente lavorativo.',
      },
    ];
    
    return Column(
      children: cardData.map((data) => 
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Icon(
              data['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(data['title'] as String),
            subtitle: Text(data['description'] as String),
          ),
        )
        .animate()
        .fadeIn(
          duration: 300.ms, 
          delay: Duration(
            milliseconds: 400 + (cardData.indexOf(data) * 100),
          ),
        )
        .slideX(
          begin: 0.2, 
          end: 0, 
          duration: 300.ms, 
          delay: Duration(
            milliseconds: 400 + (cardData.indexOf(data) * 100),
          ),
        ),
      ).toList(),
    );
  }
  
  // Costruisce la pagina degli interessi
  Widget _buildInterestsPage() {
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quali sono i suoi interessi?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Inserisci gli interessi e le passioni della persona che riceverà il regalo',
              style: Theme.of(context).textTheme.bodyMedium,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Campo di testo per gli interessi
            TextField(
              controller: _interestsController,
              decoration: InputDecoration(
                labelText: 'Interessi*',
                prefixIcon: const Icon(Icons.interests),
                hintText: 'Aggiungi interessi separati da virgola',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final interests = _interestsController.text.split(',');
                    for (final interest in interests) {
                      _addInterest(interest);
                    }
                    _interestsController.clear();
                  },
                ),
              ),
              onSubmitted: (value) {
                final interests = value.split(',');
                for (final interest in interests) {
                  _addInterest(interest);
                }
                _interestsController.clear();
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 300.ms),
            
            const SizedBox(height: 16),
            
            // Visualizza gli interessi come chip
            if (_interests.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _interests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    deleteIcon: const Icon(Icons.close, size: 18.0),
                    onDeleted: () => _removeInterest(interest),
                  );
                }).toList(),
              )
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms),
              
            if (_interests.isEmpty)
              Text(
                'Aggiungi almeno un interesse',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14.0,
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms),
              
            const SizedBox(height: 32),
            
            // Suggerimenti di interessi comuni
            Text(
              'Suggerimenti',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 500.ms),
            
            const SizedBox(height: 8),
            
            // Lista di suggerimenti
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                'Lettura', 'Musica', 'Cinema', 'Viaggi', 'Cucina', 
                'Sport', 'Tecnologia', 'Arte', 'Fotografia', 'Gaming',
                'Moda', 'Natura', 'Escursionismo', 'Yoga', 'Meditazione'
              ].map((suggestion) => 
                ActionChip(
                  label: Text(suggestion),
                  onPressed: () {
                    _addInterest(suggestion);
                  },
                )
                .animate()
                .fadeIn(
                  duration: 300.ms, 
                  delay: Duration(
                    milliseconds: 600 + (60 * ['Lettura', 'Musica', 'Cinema', 'Viaggi', 'Cucina', 
                                               'Sport', 'Tecnologia', 'Arte', 'Fotografia', 'Gaming',
                                               'Moda', 'Natura', 'Escursionismo', 'Yoga', 'Meditazione']
                                               .indexOf(suggestion)),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  // Costruisce la pagina delle preferenze regalo
  Widget _buildGiftPreferencesPage() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'category': _formData['category'],
        'budget': _formData['budget'],
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferenze del regalo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Seleziona la categoria e il budget per il regalo',
              style: Theme.of(context).textTheme.bodyMedium,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Categoria
            FormBuilderDropdown<String>(
              name: 'category',
              decoration: const InputDecoration(
                labelText: 'Categoria*',
                prefixIcon: Icon(Icons.category),
                hintText: 'Seleziona una categoria',
              ),
              initialValue: _formData['category'] ?? _categoryOptions.first,
              items: _categoryOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Seleziona una categoria';
                }
                return null;
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 300.ms),
            
            const SizedBox(height: 24),
            
            // Budget
            FormBuilderDropdown<String>(
              name: 'budget',
              decoration: const InputDecoration(
                labelText: 'Budget*',
                prefixIcon: Icon(Icons.euro),
                hintText: 'Seleziona un budget',
              ),
              initialValue: _formData['budget'] ?? _budgetOptions[2], // Default 50-100€
              items: _budgetOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Seleziona un budget';
                }
                return null;
              },
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 400.ms),
            
            const SizedBox(height: 32),
            
            // Indicazioni sulle categorie
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surface,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informazioni sulle categorie',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryInfo(
                      icon: Icons.devices,
                      title: 'Tech',
                      description: 'Dispositivi, accessori elettronici, gadget tecnologici',
                    ),
                    const Divider(),
                    _buildCategoryInfo(
                      icon: Icons.shopping_bag,
                      title: 'Moda',
                      description: 'Abbigliamento, accessori, gioielli, orologi',
                    ),
                    const Divider(),
                    _buildCategoryInfo(
                      icon: Icons.home,
                      title: 'Casa',
                      description: 'Decorazioni, utensili, arredamento, piante',
                    ),
                    const Divider(),
                    _buildCategoryInfo(
                      icon: Icons.fitness_center,
                      title: 'Sport',
                      description: 'Attrezzatura sportiva, abbigliamento tecnico, accessori fitness',
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }
  
  // Costruisce un elemento informativo sulle categorie
  Widget _buildCategoryInfo({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Costruisce la pagina dei risultati
  Widget _buildResultsPage() {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        // Mostra indicatore di caricamento
        if (state is GiftLoadingState) {
          return const LoadingIndicator(
            message: 'Generazione idee regalo in corso...',
          );
        } 
        // Mostra regali generati
        else if (state is GiftIdeasLoadedState) {
          final gifts = state.gifts;
          
          if (gifts.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'Nessun regalo trovato',
              message: 'Prova a modificare i criteri di ricerca o cambia preferenze',
              action: OutlinedButton.icon(
                onPressed: () {
                  _goToPage(0); // Torna all'inizio
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            );
          }
          
          return Column(
            children: [
              // Intestazione
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ecco le tue idee regalo!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Abbiamo generato ${gifts.length} idee regalo personalizzate',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              // Lista di regali
              Expanded(
                child: ListView.builder(
                  itemCount: gifts.length,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return GiftCard(
                      gift: gift,
                      index: index,
                      onSave: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text('Regalo salvato con successo'),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        
                        // Qui dovremmo aggiungere l'evento per salvare il regalo
                        // context.read<GiftBloc>().add(SaveGiftEvent(giftId: gift.id!, recipientId: widget.recipient?.id));
                      },
                    );
                  },
                ),
              ),
              
              // Pulsanti azione
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Pulsante per rigenerare
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<GiftBloc>().add(ResetGiftStateEvent());
                          _goToPage(0); // Torna all'inizio
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Ricomincia'),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Pulsante per modificare preferenze
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _goToPage(3), // Torna alle preferenze
                        icon: const Icon(Icons.tune),
                        label: const Text('Modifica'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } 
        // Mostra stato di errore
        else if (state is GiftErrorState) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Si è verificato un errore',
            message: state.message,
            action: OutlinedButton.icon(
              onPressed: _generateGiftIdeas,
              icon: const Icon(Icons.refresh),
              label: const Text('Riprova'),
            ),
          );
        } 
        // Mostra stato iniziale
        else {
          return EmptyState(
            icon: Icons.card_giftcard,
            title: 'Pronto per generare idee regalo',
            message: 'Compila il wizard per trovare il regalo perfetto',
            action: ElevatedButton.icon(
              onPressed: _generateGiftIdeas,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Genera ora'),
            ),
          );
        }
      },
    );
  }
}