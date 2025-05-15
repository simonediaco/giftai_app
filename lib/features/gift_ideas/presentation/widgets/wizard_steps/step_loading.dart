import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/theme/app_theme.dart';

class StepLoading extends StatelessWidget {
  const StepLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animazione di caricamento
        Lottie.asset(
          'assets/animations/loading.json', 
          width: 200,
          height: 200,
        ),
        const SizedBox(height: AppTheme.spaceL),
        
        // Testo dinamico di caricamento
        Text(
          'Stiamo trovando idee regalo perfette per te...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spaceM),
        Text(
          'Utilizziamo l\'intelligenza artificiale per analizzare le preferenze e trovare i regali con il match migliore',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}