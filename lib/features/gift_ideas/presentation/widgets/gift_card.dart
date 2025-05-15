import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gift.dart';

class GiftCard extends StatelessWidget {
  final Gift gift;
  
  const GiftCard({
    Key? key,
    required this.gift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = gift.image != null 
        ? '${AppConfig.instance.apiBaseUrl}${gift.image}'
        : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      ),
      elevation: AppTheme.elevationM,
      child: InkWell(
        onTap: () {
          // TODO: Navigare alla pagina di dettaglio del regalo
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Immagine
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.borderRadiusL),
                topRight: Radius.circular(AppTheme.borderRadiusL),
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.card_giftcard,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    gift.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spaceXS),
                  
                  // Categoria
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: AppTheme.spaceXS),
                      Text(
                        gift.category,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceXS),
                  
                  // Prezzo
                  Row(
                    children: [
                      Icon(
                        Icons.euro_outlined,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: AppTheme.spaceXS),
                      Text(
                        '${gift.price.toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  
                  // Match
                  LinearProgressIndicator(
                    value: gift.match / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: _getMatchColor(gift.match),
                  ),
                  const SizedBox(height: AppTheme.spaceXS),
                  Text(
                    'Match: ${gift.match}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  
                  // Pulsanti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implementare salvataggio
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Salva'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implementare acquisto
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Acquista'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(int match) {
    if (match >= 90) {
      return Colors.green;
    } else if (match >= 70) {
      return Colors.lime;
    } else if (match >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}