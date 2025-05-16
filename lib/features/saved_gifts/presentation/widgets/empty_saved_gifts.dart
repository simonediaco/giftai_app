// lib/features/saved_gifts/presentation/widgets/empty_saved_gifts.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';

class EmptySavedGifts extends StatelessWidget {
  const EmptySavedGifts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppTheme.spaceL),
            Text(
              'Nessun regalo salvato',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceM),
            Text(
              'Salva i tuoi regali preferiti per trovarli facilmente più tardi',
              style: Theme.of(context).textTheme.bodyMedium,
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
              icon: const Icon(Icons.search),
              label: const Text('Trova regali'),
            ),
          ],
        ),
      ),
    );
  }
}