// lib/features/saved_gifts/presentation/pages/saved_gifts_page.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';

class SavedGiftsPage extends StatelessWidget {
  static const routeName = '/saved-gifts';
  
  const SavedGiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regali Salvati'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: AppTheme.spaceL),
              Text(
                'I tuoi regali preferiti',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spaceM),
              const Text(
                'Questa funzionalità è in fase di sviluppo.\nI tuoi regali saranno presto disponibili qui.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spaceXL),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GiftWizardPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Trova nuovi regali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}