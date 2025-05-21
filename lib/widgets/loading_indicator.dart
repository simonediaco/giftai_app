import 'package:flutter/material.dart';

/// Widget per mostrare un indicatore di caricamento animato
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Indicatore di caricamento circolare
          const CircularProgressIndicator(),
          
          if (message != null) ...[
            const SizedBox(height: 16.0),
            
            // Messaggio di caricamento
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}