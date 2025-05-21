import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/gift/gift_bloc.dart';
import '../../blocs/gift/gift_event.dart';
import '../../blocs/gift/gift_state.dart';
import '../../models/gift_model.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_message.dart';
import '../../widgets/gift_card.dart';
import '../../widgets/loading_indicator.dart';

/// Schermata per visualizzare i regali salvati dall'utente
class SavedGiftsScreen extends StatefulWidget {
  const SavedGiftsScreen({Key? key}) : super(key: key);

  @override
  State<SavedGiftsScreen> createState() => _SavedGiftsScreenState();
}

class _SavedGiftsScreenState extends State<SavedGiftsScreen> {
  @override
  void initState() {
    super.initState();
    
    // Richiedi i regali salvati quando la schermata viene caricata
    context.read<GiftBloc>().add(FetchSavedGiftsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'I tuoi regali salvati',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Pulsante per filtrare
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<GiftBloc, GiftState>(
        builder: (context, state) {
          // Mostra indicatore di caricamento
          if (state is GiftLoadingState) {
            return const LoadingIndicator(
              message: 'Caricamento regali salvati...',
            );
          }
          
          // Mostra regali salvati
          else if (state is SavedGiftsLoadedState) {
            final gifts = state.gifts;
            
            if (gifts.isEmpty) {
              return EmptyState(
                icon: Icons.save_alt,
                title: 'Nessun regalo salvato',
                message: 'Salva i tuoi regali preferiti per trovarli qui',
                action: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Torna alla schermata precedente
                  },
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Trova regali'),
                ), actionText: '', onActionPressed: () {  },
              );
            }
            
            return Column(
              children: [
                // Banner in alto
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hai salvato ${gifts.length} regali. Tocca un regalo per vedere maggiori dettagli.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lista di regali salvati
                Expanded(
                  child: ListView.builder(
                    itemCount: gifts.length,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemBuilder: (context, index) {
                      final gift = gifts[index];
                      return GiftCard(
                        gift: gift,
                        index: index,
                        isSaved: true,
                        onDelete: () {
                          _showDeleteConfirmationDialog(context, gift);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          
          // Mostra stato di errore
          else if (state is GiftErrorState) {
            return ErrorMessage(
              message: state.message,
              onRetry: () {
                context.read<GiftBloc>().add(FetchSavedGiftsEvent());
              },
            );
          }
          
          // Stato sconosciuto
          else {
            return const Center(
              child: Text('Stato sconosciuto. Ricarica la pagina.'),
            );
          }
        },
      ),
    );
  }
  
  /// Mostra la finestra di dialogo per confermare la cancellazione
  void _showDeleteConfirmationDialog(BuildContext context, Gift gift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elimina regalo'),
          content: Text('Sei sicuro di voler eliminare "${gift.name}" dai tuoi regali salvati?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                // Elimina il regalo
                context.read<GiftBloc>().add(DeleteSavedGiftEvent(giftId: gift.id!));
                
                // Chiudi la finestra di dialogo
                Navigator.of(context).pop();
                
                // Mostra snackbar di conferma
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Regalo eliminato con successo'),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Annulla',
                      onPressed: () {
                        // Funzionalità annulla (da implementare)
                      },
                    ),
                  ),
                );
              },
              child: Text(
                'Elimina',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Mostra opzioni di filtro
  void _showFilterOptions(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titolo
              Text(
                'Filtra i tuoi regali',
                style: theme.textTheme.titleLarge,
              ),
              
              const SizedBox(height: 16),
              
              // Ordina per data
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Data (più recenti)'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementa la logica di ordinamento per data
                },
              ),
              
              // Ordina per prezzo (alto)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Prezzo (più alto)'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementa la logica di ordinamento per prezzo alto
                },
              ),
              
              // Ordina per prezzo (basso)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: const Text('Prezzo (più basso)'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementa la logica di ordinamento per prezzo basso
                },
              ),
              
              // Filtra per categoria
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Filtra per categoria'),
                onTap: () {
                  Navigator.pop(context);
                  _showCategoryFilterDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Mostra la finestra di dialogo per filtrare per categoria
  void _showCategoryFilterDialog(BuildContext context) {
    // Lista delle categorie
    final categories = ['Tech', 'Moda', 'Casa', 'Sport', 'Libri', 'Bellezza', 'Cibo e Bevande'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtra per categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    Navigator.pop(context);
                    // Implementa la logica di filtro per categoria
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );
  }
}