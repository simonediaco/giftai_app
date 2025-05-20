import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/blocs/gift/gift_state.dart';
import 'package:giftai/models/gift_model.dart';
import 'package:giftai/screens/saved/gift_detail_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/widgets/gift/gift_grid_item.dart';

class SavedGiftsScreen extends StatefulWidget {
  const SavedGiftsScreen({super.key});

  @override
  State<SavedGiftsScreen> createState() => _SavedGiftsScreenState();
}

class _SavedGiftsScreenState extends State<SavedGiftsScreen> {
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 1000);
  double _maxPrice = 1000;
  
  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('saved_gifts_screen');
    
    // Carica i regali salvati
    context.read<GiftBloc>().add(GiftSavedFetchRequested());
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GiftBloc>().add(GiftSavedFetchRequested());
        },
        child: BlocBuilder<GiftBloc, GiftState>(
          builder: (context, state) {
            if (state is GiftLoading && state is! GiftSavedLoadSuccess) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is GiftSavedLoadFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Errore: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GiftBloc>().add(GiftSavedFetchRequested());
                      },
                      child: const Text('Riprova'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is GiftSavedLoadSuccess) {
              if (state.gifts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nessun regalo salvato',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'I regali che salverai appariranno qui',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Vai alla schermata di generazione
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Genera idee regalo'),
                      ),
                    ],
                  ),
                );
              }
              
              // Filtra i regali in base ai filtri selezionati
              final filteredGifts = _filterGifts(state.gifts);
              
              if (filteredGifts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.filter_list,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nessun risultato con i filtri applicati',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Prova a modificare i filtri',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = null;
                            _priceRange = RangeValues(0, _maxPrice);
                          });
                        },
                        child: const Text('Rimuovi filtri'),
                      ),
                    ],
                  ),
                );
              }
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mostra i filtri attivi
                    if (_selectedCategory != null || _priceRange.start > 0 || _priceRange.end < _maxPrice)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (_selectedCategory != null)
                              Chip(
                                label: Text(_selectedCategory!),
                                onDeleted: () {
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                },
                              ),
                            if (_priceRange.start > 0 || _priceRange.end < _maxPrice)
                              Chip(
                                label: Text('€${_priceRange.start.toInt()} - €${_priceRange.end.toInt()}'),
                                onDeleted: () {
                                  setState(() {
                                    _priceRange = RangeValues(0, _maxPrice);
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredGifts.length,
                        itemBuilder: (context, index) {
                          final gift = filteredGifts[index];
                          return GiftGridItem(
                            gift: gift,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GiftDetailScreen(
                                    giftId: gift.id!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
  
  List<GiftModel> _filterGifts(List<GiftModel> gifts) {
    // Se non ci sono filtri attivi, restituisci tutti i regali
    if (_selectedCategory == null && _priceRange.start == 0 && _priceRange.end == _maxPrice) {
      return gifts;
    }
    
    return gifts.where((gift) {
      // Filtra per categoria
      if (_selectedCategory != null && gift.category.toLowerCase() != _selectedCategory!.toLowerCase()) {
        return false;
      }
      
      // Filtra per prezzo
      if (gift.price < _priceRange.start || gift.price > _priceRange.end) {
        return false;
      }
      
      return true;
    }).toList();
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtra Regali',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Filtro categoria
                  const Text(
                    'Categoria',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip(setState, 'Tech'),
                      _buildCategoryChip(setState, 'Casa'),
                      _buildCategoryChip(setState, 'Moda'),
                      _buildCategoryChip(setState, 'Bellezza'),
                      _buildCategoryChip(setState, 'Sport'),
                      _buildCategoryChip(setState, 'Libri'),
                      _buildCategoryChip(setState, 'Esperienze'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Filtro prezzo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prezzo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '€${_priceRange.start.toInt()} - €${_priceRange.end.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: _maxPrice,
                    divisions: 20,
                    labels: RangeLabels(
                      '€${_priceRange.start.toInt()}',
                      '€${_priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Pulsanti
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = null;
                              _priceRange = RangeValues(0, _maxPrice);
                            });
                            
                            // Aggiorna anche lo stato del widget principale
                            this.setState(() {
                              _selectedCategory = null;
                              _priceRange = RangeValues(0, _maxPrice);
                            });
                          },
                          child: const Text('Resetta'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Aggiorna lo stato del widget principale
                            this.setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Applica'),
                        ),
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
  
  Widget _buildCategoryChip(StateSetter setModalState, String category) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}