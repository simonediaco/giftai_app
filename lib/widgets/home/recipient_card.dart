import 'package:flutter/material.dart';
import 'package:giftai/models/recipient_model.dart';

class RecipientCard extends StatelessWidget {
  final RecipientModel recipient;
  final VoidCallback onTap;

  const RecipientCard({
    super.key,
    required this.recipient,
    required this.onTap,
  });

  String _getRelationshipEmoji() {
    final relation = recipient.relation.toLowerCase();
    if (relation.contains('amico') || relation.contains('amica')) {
      return '👨‍👨‍👦';
    } else if (relation.contains('partner') || relation.contains('compagn')) {
      return '💑';
    } else if (relation.contains('sposo') || relation.contains('sposa') || relation.contains('marit') || relation.contains('moglie')) {
      return '💍';
    } else if (relation.contains('genitore') || relation.contains('madre') || relation.contains('padre')) {
      return '👪';
    } else if (relation.contains('figli')) {
      return '👶';
    } else if (relation.contains('nonno') || relation.contains('nonna')) {
      return '👴';
    } else if (relation.contains('collega')) {
      return '👨‍💼';
    } else {
      return '🎁';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageText = recipient.age != null
        ? '${recipient.age} anni'
        : recipient.birthDate != null
            ? '${DateTime.now().year - recipient.birthDate!.year} anni'
            : 'Età non specificata';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar con emoji
              CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  _getRelationshipEmoji(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              
              // Informazioni destinatario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recipient.relation} · $ageText',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Interessi
                    if (recipient.interests.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: recipient.interests.take(3).map((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              
              // Freccia destra
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}