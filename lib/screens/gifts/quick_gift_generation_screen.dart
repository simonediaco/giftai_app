import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../blocs/gift/gift_bloc.dart';
import '../../blocs/gift/gift_event.dart';
import '../../blocs/gift/gift_state.dart';
import '../../models/gift_model.dart';
import '../../models/recipient_model.dart';
import '../../utils/amazon_affiliate_utils.dart';
import '../../utils/translations.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_message.dart';
import '../../widgets/gift_card.dart';
import '../../widgets/loading_indicator.dart';

class QuickGiftGenerationScreen extends StatefulWidget {
  final Recipient? recipient;

  const QuickGiftGenerationScreen({
    Key? key,
    this.recipient,
  }) : super(key: key);

  @override
  State<QuickGiftGenerationScreen> createState() => _QuickGiftGenerationScreenState();
}

class _QuickGiftGenerationScreenState extends State<QuickGiftGenerationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _interestsController = TextEditingController();
  final List<String> _interests = [];

  // Opzioni predefinite per i form
  final List<String> _relationOptions = RelationshipTranslations.getAllUiValues();
  final List<String> _categoryOptions = CategoryTranslations.getAllUiValues();
  final List<String> _budgetOptions = BudgetTranslations.getAllUiValues();
  final List<String> _genderOptions = GenderTranslations.getAllUiValues();

  @override
  void initState() {
    super.initState();
    
    // Se c'è un recipient, precompiliamo i campi
    if (widget.recipient != null) {
      _interests.addAll(widget.recipient!.interests);
      _updateInterestsText();
    }
  }

  @override
  void dispose() {
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
      final formData = _formKey.currentState!.value;
      
      // Verifica che ci siano interessi
      if (_interests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aggiungi almeno un interesse')),
        );
        return;
      }

      // Genera idee per un recipient esistente o crea un nuovo form per generazione rapida
      if (widget.recipient != null) {
        context.read<GiftBloc>().add(
          GenerateGiftIdeasForRecipientEvent(
            recipientId: widget.recipient!.id!,
            category: formData['category'] as String,
            budget: formData['budget'] as String,
          ),
        );
      } else {
        context.read<GiftBloc>().add(
          GenerateGiftIdeasEvent(
            name: formData['name'] as String?,
            age: formData['age'] != null ? formData['age'].toString() : null,
            gender: formData['gender'] as String?,
            relation: formData['relation'] as String,
            interests: _interests,
            category: formData['category'] as String,
            budget: formData['budget'] as String,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipient != null 
              ? 'Regali per ${widget.recipient!.name}'
              : 'Generazione Rapida',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'Suggerimenti',
            onPressed: () {
              _showTipsDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header grafico con sfondo colorato
          Container(
            width: double.infinity,
            color: theme.colorScheme.primary,
            padding: const EdgeInsets.only(
              left: 20.0, 
              right: 20.0, 
              bottom: 20.0,
            ),
            child: Text(
              widget.recipient != null
                  ? 'Trova il regalo perfetto per ${widget.recipient!.name}'
                  : 'Personalizza il tuo regalo ideale',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 300.ms),
          ),

          // Form per i dettagli
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              // Non possiamo usare margini negativi con Container
              transform: Matrix4.translationValues(0, -20, 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 16.0),
                child: _buildGiftGenerationForm(),
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms),
          ),

          // Pulsante per generare
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
            child: ElevatedButton.icon(
              onPressed: _generateGiftIdeas,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Trova Idee Regalo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 600.ms, delay: 500.ms)
          .moveY(begin: 20, end: 0, duration: 600.ms, delay: 500.ms),

          // Risultati
          Expanded(
            flex: 4,
            child: _buildResultsArea(),
          ),
        ],
      ),
    );
  }
  
  /// Mostra una finestra di dialogo con suggerimenti utili
  void _showTipsDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              const Text('Suggerimenti'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTipItem(
                  icon: Icons.person_outline,
                  title: 'Sii specifico',
                  description: 'Più dettagli fornisci sulla persona, migliori saranno i suggerimenti.',
                ),
                const SizedBox(height: 16),
                _buildTipItem(
                  icon: Icons.interests,
                  title: 'Interessi precisi',
                  description: 'Aggiungi interessi concreti come "cucina italiana" invece di "cibo".',
                ),
                const SizedBox(height: 16),
                _buildTipItem(
                  icon: Icons.category,
                  title: 'Cambia categoria',
                  description: 'Prova diverse categorie per scoprire più idee regalo.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Ho capito'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  
  /// Costruisce un elemento di suggerimento
  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.secondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Costruisce il form per la generazione di regali
  Widget _buildGiftGenerationForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        if (widget.recipient != null) ...{
          'name': widget.recipient!.name,
          'age': widget.recipient!.age,
          'gender': widget.recipient!.gender,
          'relation': widget.recipient!.relation,
        },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campi per nuovo recipient (solo se non c'è un recipient)
          if (widget.recipient == null) ...[
            // Nome
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Nome (opzionale)',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Età e genere in una row
            Row(
              children: [
                // Età
                Expanded(
                  child: FormBuilderTextField(
                    name: 'age',
                    decoration: const InputDecoration(
                      labelText: 'Età (opzionale)',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                
                const SizedBox(width: 16.0),
                
                // Genere
                Expanded(
                  child: FormBuilderDropdown<String>(
                    name: 'gender',
                    decoration: const InputDecoration(
                      labelText: 'Genere (opzionale)',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: _genderOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16.0),
            
            // Relazione
            FormBuilderDropdown<String>(
              name: 'relation',
              decoration: const InputDecoration(
                labelText: 'Relazione*',
                prefixIcon: Icon(Icons.connect_without_contact),
              ),
              initialValue: _relationOptions.first,
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
            ),
            
            const SizedBox(height: 16.0),
          ],
          
          // Interessi (con chip)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),
              
              const SizedBox(height: 8.0),
              
              // Visualizza gli interessi come chip
              Wrap(
                spacing: 8.0,
                children: _interests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    deleteIcon: const Icon(Icons.close, size: 18.0),
                    onDeleted: () => _removeInterest(interest),
                  );
                }).toList(),
              ),
              
              if (_interests.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Aggiungi almeno un interesse',
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16.0),
          
          // Categoria e budget in una row
          Row(
            children: [
              // Categoria
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'category',
                  decoration: const InputDecoration(
                    labelText: 'Categoria*',
                    prefixIcon: Icon(Icons.category),
                  ),
                  initialValue: _categoryOptions.first,
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
                ),
              ),
              
              const SizedBox(width: 16.0),
              
              // Budget
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'budget',
                  decoration: const InputDecoration(
                    labelText: 'Budget*',
                    prefixIcon: Icon(Icons.euro),
                  ),
                  initialValue: _budgetOptions[2], // Default 50-100€
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Filtri per categoria e prezzo
  String? _selectedCategoryFilter;
  String? _selectedPriceFilter;
  String? _selectedSortOption;
  
  // Lista di regali popolari precaricati
  final List<Gift> _popularGifts = [
    Gift(
      name: 'Cuffie Wireless Premium',
      price: 79.99,
      match: 92,
      category: 'Tech',
      image: 'https://images.pexels.com/photos/3394665/pexels-photo-3394665.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      description: 'Cuffie wireless con cancellazione del rumore e qualità audio superiore.',
    ),
    Gift(
      name: 'Set Aromaterapia Deluxe',
      price: 49.99,
      match: 88,
      category: 'Bellezza',
      image: 'https://images.pexels.com/photos/3997993/pexels-photo-3997993.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      description: 'Set completo con diffusore e 6 oli essenziali per un\'esperienza rilassante.',
    ),
    Gift(
      name: 'Smartwatch Fitness',
      price: 129.99,
      match: 85,
      category: 'Tech',
      image: 'https://images.pexels.com/photos/437037/pexels-photo-437037.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      description: 'Monitoraggio completo della salute, notifiche e design elegante.',
    ),
  ];

  // Costruisce l'area dei risultati con filtri e suggerimenti
  Widget _buildResultsArea() {
    final theme = Theme.of(context);
    
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        // Stato iniziale - mostro regali popolari
        if (state is GiftInitialState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titolo per i regali popolari
                    Row(
                      children: [
                        Icon(Icons.trending_up, 
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Regali più ricercati',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Idee regalo popolari che potrebbero ispirarti',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms),
              
              Expanded(
                child: ListView.builder(
                  itemCount: _popularGifts.length,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  itemBuilder: (context, index) {
                    return GiftCard(
                      gift: _popularGifts[index],
                      index: index,
                      onSave: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Regalo salvato con successo')),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } 
        // Stato di caricamento
        else if (state is GiftLoadingState) {
          return LoadingIndicator(
            message: 'Ricerca in corso...',
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            duration: 1.seconds, 
            curve: Curves.easeInOut,
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05),
          );
        } 
        // Stato con risultati caricati
        else if (state is GiftIdeasLoadedState) {
          final allGifts = state.gifts;
          
          if (allGifts.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'Nessun regalo trovato',
              message: 'Prova a modificare i criteri di ricerca o cambia preferenze',
              action: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    // Reset dei filtri
                    _selectedCategoryFilter = null;
                    _selectedPriceFilter = null;
                    _selectedSortOption = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reimposta filtri'),
              ),
            );
          }
          
          // Applica filtri
          List<Gift> filteredGifts = _filterGifts(allGifts);
          
          return Column(
            children: [
              // Sezione filtri
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredGifts.length} risultati trovati',
                          style: theme.textTheme.titleSmall,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _showFiltersBottomSheet(context, allGifts);
                          },
                          icon: const Icon(Icons.filter_list, size: 18),
                          label: const Text('Filtra'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    
                    // Chip di filtri attivi
                    if (_selectedCategoryFilter != null || 
                        _selectedPriceFilter != null || 
                        _selectedSortOption != null)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (_selectedCategoryFilter != null)
                              _buildFilterChip(
                                label: _selectedCategoryFilter!,
                                onDeleted: () {
                                  setState(() {
                                    _selectedCategoryFilter = null;
                                  });
                                },
                              ),
                              
                            if (_selectedPriceFilter != null)
                              _buildFilterChip(
                                label: _selectedPriceFilter!,
                                onDeleted: () {
                                  setState(() {
                                    _selectedPriceFilter = null;
                                  });
                                },
                              ),
                              
                            if (_selectedSortOption != null)
                              _buildFilterChip(
                                label: 'Ordinamento: $_selectedSortOption',
                                onDeleted: () {
                                  setState(() {
                                    _selectedSortOption = null;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Lista di regali filtrati
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGifts.length,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  itemBuilder: (context, index) {
                    final gift = filteredGifts[index];
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
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                        
                        // Qui dovremmo aggiungere l'evento per salvare il regalo
                        // context.read<GiftBloc>().add(SaveGiftEvent(giftId: gift.id!, recipientId: widget.recipient?.id));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } 
        // Stato di errore
        else if (state is GiftErrorState) {
          return ErrorMessage(
            message: state.message,
            onRetry: _generateGiftIdeas,
          );
        } 
        // Stato sconosciuto
        else {
          return const Center(
            child: Text('Stato sconosciuto'),
          );
        }
      },
    );
  }
  
  /// Costruisce un chip per i filtri attivi
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  /// Filtra i regali in base ai filtri selezionati
  List<Gift> _filterGifts(List<Gift> gifts) {
    List<Gift> filteredGifts = List.from(gifts);
    
    // Filtra per categoria
    if (_selectedCategoryFilter != null) {
      filteredGifts = filteredGifts.where(
        (gift) => gift.category == _selectedCategoryFilter
      ).toList();
    }
    
    // Filtra per prezzo
    if (_selectedPriceFilter != null) {
      final priceRanges = {
        'Sotto 20€': (Gift g) => g.price < 20,
        '20-50€': (Gift g) => g.price >= 20 && g.price <= 50,
        '50-100€': (Gift g) => g.price > 50 && g.price <= 100,
        '100-200€': (Gift g) => g.price > 100 && g.price <= 200,
        'Sopra 200€': (Gift g) => g.price > 200,
      };
      
      if (priceRanges.containsKey(_selectedPriceFilter)) {
        filteredGifts = filteredGifts.where(
          priceRanges[_selectedPriceFilter]!
        ).toList();
      }
    }
    
    // Ordina i risultati
    if (_selectedSortOption != null) {
      switch (_selectedSortOption) {
        case 'Prezzo (min-max)':
          filteredGifts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Prezzo (max-min)':
          filteredGifts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Compatibilità':
          filteredGifts.sort((a, b) => b.match.compareTo(a.match));
          break;
      }
    }
    
    return filteredGifts;
  }

  /// Mostra la finestra di dialogo per i filtri
  void _showFiltersBottomSheet(BuildContext context, List<Gift> gifts) {
    final theme = Theme.of(context);
    
    // Estrai tutte le categorie uniche dai regali
    final categories = gifts.map((gift) => gift.category).toSet().toList();
    
    // Opzioni per il prezzo
    final priceRanges = ['Sotto 20€', '20-50€', '50-100€', '100-200€', 'Sopra 200€'];
    
    // Opzioni per l'ordinamento
    final sortOptions = ['Compatibilità', 'Prezzo (min-max)', 'Prezzo (max-min)'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtra risultati',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtro Categoria
                  Text(
                    'Categoria',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      // Opzione "Tutte" per resettare il filtro
                      ChoiceChip(
                        label: const Text('Tutte'),
                        selected: _selectedCategoryFilter == null,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _selectedCategoryFilter = null;
                            });
                            setState(() {
                              _selectedCategoryFilter = null;
                            });
                          }
                        },
                      ),
                      ...categories.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategoryFilter == category,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedCategoryFilter = selected ? category : null;
                            });
                            setState(() {
                              _selectedCategoryFilter = selected ? category : null;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtro Prezzo
                  Text(
                    'Fascia di prezzo',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      // Opzione "Tutte" per resettare il filtro
                      ChoiceChip(
                        label: const Text('Tutte'),
                        selected: _selectedPriceFilter == null,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _selectedPriceFilter = null;
                            });
                            setState(() {
                              _selectedPriceFilter = null;
                            });
                          }
                        },
                      ),
                      ...priceRanges.map((range) {
                        return ChoiceChip(
                          label: Text(range),
                          selected: _selectedPriceFilter == range,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedPriceFilter = selected ? range : null;
                            });
                            setState(() {
                              _selectedPriceFilter = selected ? range : null;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Ordinamento
                  Text(
                    'Ordina per',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      // Opzione "Nessuno" per resettare l'ordinamento
                      ChoiceChip(
                        label: const Text('Nessun ordine'),
                        selected: _selectedSortOption == null,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _selectedSortOption = null;
                            });
                            setState(() {
                              _selectedSortOption = null;
                            });
                          }
                        },
                      ),
                      ...sortOptions.map((option) {
                        return ChoiceChip(
                          label: Text(option),
                          selected: _selectedSortOption == option,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedSortOption = selected ? option : null;
                            });
                            setState(() {
                              _selectedSortOption = selected ? option : null;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Pulsanti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Pulsante per resettare tutti i filtri
                      OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCategoryFilter = null;
                            _selectedPriceFilter = null;
                            _selectedSortOption = null;
                          });
                          setState(() {
                            _selectedCategoryFilter = null;
                            _selectedPriceFilter = null;
                            _selectedSortOption = null;
                          });
                        },
                        child: const Text('Resetta tutto'),
                      ),
                      
                      // Pulsante per applicare i filtri
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Applica filtri'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}