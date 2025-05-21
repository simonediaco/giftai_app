import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giftai/models/gift_model.dart';
import 'package:giftai/utils/image_utils.dart';
import 'package:giftai/utils/price_utils.dart';

class GiftGridItem extends StatelessWidget {
  final Gift gift;
  final VoidCallback onTap;

  const GiftGridItem({
    super.key,
    required this.gift,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: gift.image!.startsWith('assets/')
                      ? Image.asset(
                          gift.image!,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: ImageUtils.getFullImageUrl(gift.image!),
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
                
                // Badge percentuale match
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMatchColor(gift.match),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${gift.match}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Informazioni
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    PriceUtils.formatPrice(gift.price),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      gift.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
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
    if (match >= 80) {
      return Colors.green;
    } else if (match >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}