// lib/features/saved_gifts/presentation/widgets/saved_gift_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/saved_gift.dart';

class SavedGiftCard extends StatelessWidget {
  final SavedGift gift;
  final VoidCallback onDelete;
  
  const SavedGiftCard({
    Key? key,
    required this.gift,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = gift.image != null 
        ? '${AppConfig.instance.apiBaseUrl}${gift.image}'
        : null;
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implementare visualizzazione dettaglio
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.borderRadiusL),
                bottomLeft: Radius.circular(AppTheme.borderRadiusL),
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.card_giftcard,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
            
            // Contenuto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Categoria
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                          child: Text(
                            gift.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        
                        // Match
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getMatchColor(gift.match).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: _getMatchColor(gift.match),
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${gift.match}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getMatchColor(gift.match),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceXS),
                    
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
                    
                    // Prezzo
                    Text(
                      '${gift.price.toStringAsFixed(2)}€',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceS),
                    
                    // Data
                    Row(
                      children: [
                        Text(
                          'Salvato il ${_formatDate(gift.dateAdded)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        
                        // Azioni
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getMatchColor(int match) {
    if (match >= 90) {
      return Colors.green.shade700;
    } else if (match >= 70) {
      return Colors.lightGreen.shade700;
    } else if (match >= 50) {
      return Colors.orange.shade700;
    } else {
      return Colors.red.shade700;
    }
  }
}