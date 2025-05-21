import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/gift_model.dart';
import '../utils/amazon_affiliate_utils.dart';

/// Widget per visualizzare un regalo come card con animazioni ed effetti moderni
class GiftCard extends StatelessWidget {
  final Gift gift;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final bool isSaved;
  final int index; // Per animazioni sequenziali

  const GiftCard({
    Key? key,
    required this.gift,
    this.onSave,
    this.onDelete,
    this.isSaved = false,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      elevation: 4.0,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Immagine del regalo con badge di compatibilità
          Stack(
            children: [
              // Immagine
              _buildGiftImage(theme),
              
              // Badge di compatibilità
              Positioned(
                top: 12,
                right: 12,
                child: _buildMatchBadge(theme),
              ),
              
              // Prezzo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    gift.formattedPrice,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Contenuto della card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome del regalo e categoria
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome
                    Expanded(
                      child: Text(
                        gift.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(width: 8.0),
                    
                    // Categoria
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        gift.category,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12.0),
                
                // Descrizione del regalo
                if (gift.description != null) ...[
                  Text(
                    gift.description!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16.0),
                ],
                
                // Indicatore di compatibilità
                _buildMatchIndicator(theme),
                
                const SizedBox(height: 16.0),
                
                // Pulsanti di azione
                _buildActionButtons(theme),
              ],
            ),
          ),
        ],
      ),
    )
    .animate(delay: Duration(milliseconds: 100 * index)) // Animazione sequenziale basata sull'indice
    .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
    .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad)
    .scale(begin: const Offset(0.95, 0.95), duration: 400.ms);
  }

  /// Costruisce l'immagine del regalo con effetti moderni
  Widget _buildGiftImage(ThemeData theme) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: SizedBox(
        height: 220.0, // Immagine più grande
        child: gift.image != null
            ? Hero(
                tag: 'gift_image_${gift.id ?? gift.name}',
                child: Image.network(
                  gift.image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage(theme);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoading(theme);
                  },
                ),
              )
            : _buildPlaceholderImage(theme),
      ),
    );
  }

  /// Costruisce un'immagine placeholder quando non c'è un'immagine
  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.card_giftcard,
          size: 80.0,
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Costruisce un indicatore di caricamento per l'immagine
  Widget _buildImageLoading(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  /// Costruisce un badge di compatibilità
  Widget _buildMatchBadge(ThemeData theme) {
    // Colore e icona basati sul punteggio di compatibilità
    Color getBadgeColor() {
      if (gift.match >= 90) return Colors.green;
      if (gift.match >= 70) return Colors.lightGreen;
      if (gift.match >= 50) return Colors.amber;
      return Colors.orange;
    }

    IconData getBadgeIcon() {
      if (gift.match >= 90) return Icons.star;
      if (gift.match >= 70) return Icons.thumb_up;
      if (gift.match >= 50) return Icons.check_circle;
      return Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: getBadgeColor(),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getBadgeIcon(),
            color: Colors.white,
            size: 16.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            '${gift.match}%',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Costruisce l'indicatore di compatibilità
  Widget _buildMatchIndicator(ThemeData theme) {
    // Colore dell'indicatore basato sul punteggio di compatibilità
    Color getColorForMatch() {
      if (gift.match >= 80) return Colors.green;
      if (gift.match >= 60) return Colors.amber;
      return Colors.orange;
    }

    // Messaggio basato sul punteggio di compatibilità
    String getMatchMessage() {
      if (gift.match >= 80) return 'Compatibilità eccellente';
      if (gift.match >= 60) return 'Buona compatibilità';
      return 'Compatibilità moderata';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics,
              size: 16.0,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4.0),
            Text(
              getMatchMessage(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: getColorForMatch(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        LinearProgressIndicator(
          value: gift.match / 100,
          color: getColorForMatch(),
          backgroundColor: theme.colorScheme.surfaceVariant,
          minHeight: 8.0,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ],
    );
  }

  /// Costruisce i pulsanti di azione
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pulsante per salvare o eliminare il regalo
        if (isSaved && onDelete != null)
          OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Elimina'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
          )
        else if (!isSaved && onSave != null)
          OutlinedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.favorite_border),
            label: const Text('Salva idea'),
          ),
          
        // Pulsante per acquistare su Amazon
        ElevatedButton.icon(
          onPressed: () => _launchAmazonLink(gift.name),
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Su Amazon'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9900), // Colore Amazon
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Apre il link di Amazon per acquistare il regalo
  Future<void> _launchAmazonLink(String productName) async {
    final Uri url = Uri.parse(AmazonAffiliateUtils.generateAffiliateLink(productName));
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Gestione dell'errore (potrebbe essere ignorato o gestito diversamente)
      print('Errore nell\'apertura del link: $e');
    }
  }
}