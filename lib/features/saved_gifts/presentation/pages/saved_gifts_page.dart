// lib/features/saved_gifts/presentation/pages/saved_gifts_page.dart
// Evoluzione della pagina salvati (versione completa)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/saved_gifts_bloc.dart';
import '../bloc/saved_gifts_event.dart';
import '../bloc/saved_gifts_state.dart';
import '../widgets/saved_gift_card.dart';
import '../widgets/empty_saved_gifts.dart';

class SavedGiftsPage extends StatefulWidget {
  static const routeName = '/saved-gifts';
  
  const SavedGiftsPage({Key? key}) : super(key: key);

  @override
  State<SavedGiftsPage> createState() => _SavedGiftsPageState();
}

class _SavedGiftsPageState extends State<SavedGiftsPage> {
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 500);
  
  @override
  void initState() {
    super.initState();
    context.read<SavedGiftsBloc>().add(FetchSavedGifts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regali Salvati'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<SavedGiftsBloc, SavedGiftsState>(
        builder: (context, state) {
          if (state is SavedGiftsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedGiftsLoaded) {
            final gifts = state.gifts;
            
            if (gifts.isEmpty) {
              return const EmptySavedGifts();
            }
            
            // Filtra i regali in base alle selezioni
            final filteredGifts = gifts.where((gift) {
              final matchesCategory = _selectedCategory == null || 
                  gift.category == _selectedCategory;
              
              final matchesPrice = gift.price >= _priceRange.start && 
                  gift.price <= _priceRange.end;
              
              return matchesCategory && matchesPrice;
            }).toList();
            
            return Column(
              children: [
                // Riepilogo filtri attivi (se presenti)
                if (_selectedCategory != null || _priceRange != const RangeValues(0, 500))
                  Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 18),
                        const SizedBox(width: AppTheme.spaceS),
                        Text(
                          'Filtri attivi:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceS),
                        if (_selectedCategory != null)
                          Chip(
                            label: Text(_selectedCategory!),
                            onDeleted: () {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                          ),
                        if (_priceRange != const RangeValues(0, 500))
                          Chip(
                            label: Text('${_priceRange.start.round()}€-${_priceRange.end.round()}€'),
                            onDeleted: () {
                              setState(() {
                                _priceRange = const RangeValues(0, 500);
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                
                // Lista dei regali salvati
                Expanded(
                  child: filteredGifts.isEmpty
                      ? Center(
                          child: Text(
                            'Nessun regalo corrisponde ai filtri selezionati',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.spaceM),
                          itemCount: filteredGifts.length,
                          itemBuilder: (context, index) {
                            final gift = filteredGifts[index];
                            return SavedGiftCard(
                              gift: gift,
                              onDelete: () {
                                context.read<SavedGiftsBloc>().add(RemoveSavedGift(gift.id));
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is SavedGiftsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'Si è verificato un errore',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceL),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SavedGiftsBloc>().add(FetchSavedGifts());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusL)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Text(
                              'Filtra regali',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        
                        // Filtro categoria
                        Text(
                          'Categoria',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spaceM),
                        Wrap(
                          spacing: AppTheme.spaceS,
                          children: [
                            _buildCategoryChip(setState, null, 'Tutte'),
                            _buildCategoryChip(setState, 'Tech', 'Tech'),
                            _buildCategoryChip(setState, 'Casa', 'Casa'),
                            _buildCategoryChip(setState, 'Moda', 'Moda'),
                            _buildCategoryChip(setState, 'Sport', 'Sport'),
                            _buildCategoryChip(setState, 'Bellezza', 'Bellezza'),
                            _buildCategoryChip(setState, 'Hobby', 'Hobby'),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spaceL),
                        
                        // Filtro prezzo
                        Row(
                          children: [
                            Text(
                              'Prezzo',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Text(
                              '${_priceRange.start.round()}€ - ${_priceRange.end.round()}€',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 500,
                          divisions: 50,
                          labels: RangeLabels(
                            '${_priceRange.start.round()}€',
                            '${_priceRange.end.round()}€',
                          ),
                          onChanged: (values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                        const SizedBox(height: AppTheme.spaceXL),
                        
                        // Pulsanti azione
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedCategory = null;
                                    _priceRange = const RangeValues(0, 500);
                                  });
                                },
                                child: const Text('Reset'),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spaceM),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  this.setState(() {
                                    // I valori sono già aggiornati nello state locale
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Applica'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildCategoryChip(StateSetter setState, String? value, String label) {
    final isSelected = _selectedCategory == value;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? value : null;
        });
      },
    );
  }
}