import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gift.dart';
import 'gift_card.dart';

class GiftResultList extends StatelessWidget {
  final List<Gift> gifts;
  
  const GiftResultList({
    Key? key,
    required this.gifts,
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
          // TODO: Implementare salvataggio di tutti i regali
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
}