import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giftai/models/gift_model.dart';
import 'package:giftai/utils/image_utils.dart';
import 'package:giftai/utils/price_utils.dart';

class GiftResultCard extends StatelessWidget {
  final GiftModel gift;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onViewOnAmazon;

  const GiftResultCard({
    super.key,
    required this.gift,
    required this.onSave,
    required this.onShare,
    required this.onViewOnAmazon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine regalo
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: gift.image.startsWith('assets/')
                      ? Image.asset(
                          gift.image,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: ImageUtils.getFullImageUrl(gift.image),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            ImageUtils.getImageForCategory(gift.category),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                
                // Badge categoria
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      gift.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                
                // Badge match
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getMatchColor(gift.match),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Match ${gift.match}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Contenuto
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome regalo
                  Text(
                    gift.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Prezzo
                  Text(
                    PriceUtils.formatPrice(gift.price),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Descrizione
                  if (gift.description != null && gift.description!.isNotEmpty) ...[
                    Text(
                      gift.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Pulsanti azioni
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        context,
                        icon: Icons.bookmark_border,
                        label: 'Salva',
                        onTap: onSave,
                      ),
                      _buildActionButton(
                        context,
                        icon: Icons.share,
                        label: 'Condividi',
                        onTap: onShare,
                      ),
                      _buildActionButton(
                        context,
                        icon: Icons.shopping_cart_outlined,
                        label: 'Amazon',
                        onTap: onViewOnAmazon,
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
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getMatchColor(int match) {
    if (match >= 80) {
      return Colors.green;
    } else if (match >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}