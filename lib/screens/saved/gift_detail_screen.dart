import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/blocs/gift/gift_state.dart';
import 'package:giftai/utils/image_utils.dart';
import 'package:giftai/utils/price_utils.dart';
import 'package:giftai/widgets/common/primary_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GiftDetailScreen extends StatefulWidget {
  final int giftId;

  const GiftDetailScreen({
    super.key,
    required this.giftId,
  });

  @override
  State<GiftDetailScreen> createState() => _GiftDetailScreenState();
}

class _GiftDetailScreenState extends State<GiftDetailScreen> {
  @override
  void initState() {
    super.initState();
    
    // Carica il dettaglio del regalo
    context.read<GiftBloc>().add(
      GiftSavedDetailRequested(id: widget.giftId),
    );
  }
  
  Future<void> _launchAmazonUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile aprire Amazon')),
      );
    }
  }
  
  void _shareGift(String name, double price) {
    Share.share(
      'Ho trovato questo regalo con GiftAI: $name a ${PriceUtils.formatPrice(price)}',
      subject: 'Idea regalo da GiftAI',
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Regalo'),
      ),
      body: BlocBuilder<GiftBloc, GiftState>(
        builder: (context, state) {
          if (state is GiftLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is GiftSavedDetailFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Errore: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GiftBloc>().add(
                        GiftSavedDetailRequested(id: widget.giftId),
                      );
                    },
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          if (state is GiftSavedDetailSuccess) {
            final gift = state.gift;
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Immagine
                  Hero(
                    tag: 'gift_image_${gift.id}',
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
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
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Intestazione
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                gift.category,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getMatchColor(gift.match).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: _getMatchColor(gift.match),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Match ${gift.match}%',
                                    style: TextStyle(
                                      color: _getMatchColor(gift.match),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Nome e prezzo
                        Text(
                          gift.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          PriceUtils.formatPrice(gift.price),
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Descrizione
                        if (gift.description != null && gift.description!.isNotEmpty) ...[
                          const Text(
                            'Descrizione',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(gift.description!),
                          const SizedBox(height: 24),
                        ],
                        
                        // Note
                        if (gift.notes != null && gift.notes!.isNotEmpty) ...[
                          const Text(
                            'Note',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(gift.notes!),
                          ),
                          const SizedBox(height: 24),
                        ],
                        
                        // Pulsanti azione
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _shareGift(gift.name, gift.price);
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Condividi'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Vedi su Amazon',
                                icon: Icons.shopping_cart,
                                onPressed: () {
                                  _launchAmazonUrl(gift.getAmazonUrl());
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
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