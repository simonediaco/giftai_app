import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gift.dart';
import 'gift_card.dart';

class GiftResultList extends StatelessWidget {
  final List<Gift> gifts;
  
  const GiftResultList({
    Key? key,
    required this.gifts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.celebration_outlined),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Text(
                  'Abbiamo trovato ${gifts.length} idee regalo per te!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                tooltip: 'Nuova ricerca',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return GiftCard(gift: gift);
            },
          ),
        ),
      ],
    );
  }
}