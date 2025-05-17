import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recipient.dart';

class RecipientCard extends StatelessWidget {
  final Recipient recipient;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  
  const RecipientCard({
    Key? key,
    required this.recipient,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcola l'età dalla data di nascita
    final age = DateTime.now().year - recipient.birthDate.year;
    final birthdayThisYear = DateTime(
      DateTime.now().year,
      recipient.birthDate.month,
      recipient.birthDate.day,
    );
    final isBirthdayPassed = DateTime.now().isAfter(birthdayThisYear);
    final adjustedAge = isBirthdayPassed ? age : age - 1;
    
    // Mappa dei generi per visualizzazione
    final genderMap = {
      'M': 'Uomo',
      'F': 'Donna',
      'NB': 'Non Binario',
      'X': 'Non Specificato',
      'O': 'Altro'
    };
    
    // Mappa delle relazioni per visualizzazione in italiano
    // Mappa delle relazioni per visualizzazione in italiano
    final relationMap = {
      'amico': 'Amico',
      'familiare': 'Familiare',
      'partner': 'Partner',
      'collega': 'Collega',
      'altro': 'Altro',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Row(
            children: [
              // Avatar basato sul genere
              CircleAvatar(
                radius: 30,
                backgroundColor: _getAvatarColor(recipient.gender),
                child: Text(
                  recipient.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              
              // Informazioni
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          recipient.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($adjustedAge)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      '${genderMap[recipient.gender] ?? recipient.gender} · ${DateFormat('dd/MM/yyyy').format(recipient.birthDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (recipient.relation != null)
                      Text(
                        relationMap[recipient.relation!] ?? recipient.relation!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (recipient.interests.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: recipient.interests.take(3).map((interest) => 
                          Chip(
                            label: Text(
                              interest,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )
                        ).toList(),
                      ),
                  ],
                ),
              ),
              
              // Pulsanti azioni
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getAvatarColor(String gender) {
    switch (gender) {
      case 'M':
        return Colors.blue;
      case 'F':
        return Colors.pink;
      case 'NB':
        return Colors.green;
      case 'X':
        return Colors.yellow;
      case 'O':
      default:
        return Colors.purple;
    }
  }
}