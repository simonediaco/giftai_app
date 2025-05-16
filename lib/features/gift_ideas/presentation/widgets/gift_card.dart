import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../saved_gifts/presentation/bloc/saved_gifts_state.dart';
import '../../domain/entities/gift.dart';
import '../../../../features/saved_gifts/domain/entities/saved_gift.dart';
import '../../../../features/saved_gifts/presentation/bloc/saved_gifts_bloc.dart';
import '../../../../features/saved_gifts/presentation/bloc/saved_gifts_event.dart';

class GiftCard extends StatefulWidget {
  final Gift gift;
  
  const GiftCard({
    Key? key,
    required this.gift,
  }) : super(key: key);

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;
  
  // Aggiungi questa funzione nel widget _GiftCardState
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Controlla se questo regalo è già nei preferiti
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedGiftsState = context.read<SavedGiftsBloc>().state;
      if (savedGiftsState is SavedGiftsLoaded) {
        final isAlreadySaved = savedGiftsState.gifts.any((gift) => gift.id == widget.gift.id);
        if (isAlreadySaved) {
          setState(() {
            _isFavorite = true;
          });
        }
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    if (_isFavorite) {
      // Salva il regalo
      final savedGift = SavedGift(
        id: widget.gift.id,
        name: widget.gift.name,
        price: widget.gift.price,
        match: widget.gift.match,
        image: widget.gift.image,
        category: widget.gift.category,
        dateAdded: DateTime.now(),
      );
      
      context.read<SavedGiftsBloc>().add(AddSavedGift(savedGift));
      
      // Mostra un messaggio di conferma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.gift.name} salvato nei preferiti'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'VEDI',
            textColor: Colors.white,
            onPressed: () {
              // Naviga alla pagina dei regali salvati
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Vai alla tab Salvati (indice 2)
              // Questo dipende da come è strutturata la tua navigazione
            },
          ),
        ),
      );
    } else {
      // Rimuovi dai preferiti
      context.read<SavedGiftsBloc>().add(RemoveSavedGift(widget.gift.id));
      
      // Mostra un messaggio di conferma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.gift.name} rimosso dai preferiti'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.gift.image != null 
        ? '${AppConfig.instance.apiBaseUrl}${widget.gift.image}'
        : null;
    
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spaceL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
          ),
          elevation: AppTheme.elevationM,
          child: InkWell(
            onTap: () {
              // TODO: Mostrare dettagli del regalo
            },
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Immagine con badge di match
                Stack(
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
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.card_giftcard,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.card_giftcard,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    
                    // Badge del match
                    Positioned(
                      top: AppTheme.spaceM,
                      right: AppTheme.spaceM,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceM,
                          vertical: AppTheme.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: _getMatchColor(widget.gift.match),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: AppTheme.spaceXS),
                            Text(
                              '${widget.gift.match}% Match',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Badge categoria
                    Positioned(
                      top: AppTheme.spaceM,
                      left: AppTheme.spaceM,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceM,
                          vertical: AppTheme.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                        ),
                        child: Text(
                          widget.gift.category,
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
                
                // Contenuto
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome
                      Text(
                        widget.gift.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spaceS),
                      
                      // Prezzo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceM,
                              vertical: AppTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                            ),
                            child: Text(
                              '${widget.gift.price.toStringAsFixed(2)}€',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceM),
                      
                      // Pulsanti azione
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : null,
                              ),
                              label: Text(_isFavorite ? 'Salvato' : 'Salva'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: _isFavorite 
                                      ? Colors.red 
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceM),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implementare acquisto
                              },
                              icon: const Icon(Icons.shopping_cart_outlined),
                              label: const Text('Acquista'),
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
        ),
      ),
    );
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