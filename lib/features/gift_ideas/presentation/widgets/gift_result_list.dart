import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/recipients/domain/entities/recipient.dart';
import '../../../../features/recipients/presentation/bloc/recipients_bloc.dart';
import '../../../../features/recipients/presentation/bloc/recipients_event.dart';
import '../../../../features/recipients/presentation/pages/add_recipient_page.dart';
import '../../domain/entities/gift.dart';
import '../models/gift_wizard_data.dart';
import 'gift_card.dart';

class GiftResultList extends StatelessWidget {
  final List<Gift> gifts;
  final GiftWizardData? wizardData; // Reso opzionale
  
  const GiftResultList({
    Key? key,
    required this.gifts,
    this.wizardData, // Reso opzionale
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idee Regalo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Nuova ricerca',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con risultati
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.borderRadiusL),
                bottomRight: Radius.circular(AppTheme.borderRadiusL),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spaceS),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.celebration,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Abbiamo trovato ${gifts.length} idee regalo!',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'In base alle tue preferenze, ecco cosa abbiamo selezionato',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Banner per salvare il destinatario - solo se wizardData è disponibile
                if (wizardData != null && (wizardData!.name != null || wizardData!.age != null))
                  Container(
                    margin: const EdgeInsets.only(top: AppTheme.spaceM),
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppTheme.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vuoi salvare questo destinatario?',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Salvalo per usarlo di nuovo in futuro',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showSaveRecipientDialog(context),
                          child: const Text('Salva'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Lista regali
          Expanded(
            child: gifts.isEmpty
                ? const Center(
                    child: Text('Nessun regalo trovato'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    itemCount: gifts.length,
                    itemBuilder: (context, index) {
                      return GiftCard(gift: gifts[index]);
                    },
                  ),
          ),
        ],
      ),
      // FAB per salvare tutti
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Salvare tutti i regali come preferiti
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funzionalità in arrivo!'),
            ),
          );
        },
        icon: const Icon(Icons.favorite),
        label: const Text('Salva Tutti'),
      ),
    );
  }
  
  void _showSaveRecipientDialog(BuildContext context) {
    // Solo se wizardData è disponibile
    if (wizardData == null) return;
    
    // Creiamo la base di un nuovo destinatario con i dati disponibili
    final initialData = Recipient(
      id: -1, // ID temporaneo
      name: wizardData!.name ?? 'Destinatario',
      gender: wizardData!.gender,
      birthDate: DateTime(DateTime.now().year - (wizardData!.age ?? 30)), // Stima approssimativa
      relation: wizardData!.relation,
      interests: wizardData!.interests,
    );
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Salvare destinatario?'),
        content: const Text(
          'Per completare il salvataggio, dovrai specificare alcuni dati aggiuntivi come la data di nascita completa.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Apri la pagina per completare i dati
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddRecipientPage(
                    initialData: initialData,
                  ),
                ),
              );
            },
            child: const Text('Continua'),
          ),
        ],
      ),
    );
  }
}