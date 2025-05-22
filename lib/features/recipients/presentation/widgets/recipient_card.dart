import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart' as utils; // ✅ Import utility
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
    // ✅ USA utility comune invece di logica duplicata
    final age = utils.DateUtils.calculateAge(recipient.birthDate);
    final isBirthday = utils.DateUtils.isBirthdayToday(recipient.birthDate);
    
    // Mappa dei generi per visualizzazione
    final genderMap = {
      'M': 'Uomo',
      'F': 'Donna',
      'NB': 'Non Binario',
      'X': 'Non Specificato',
      'O': 'Altro'
    };
    
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
      // ✅ Evidenzia se è il compleanno
      elevation: isBirthday ? AppTheme.elevationL : AppTheme.elevationS,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          // ✅ Bordo speciale per compleanni
          decoration: isBirthday ? BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ) : null,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Row(
              children: [
                // Avatar con indicatore compleanno
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _getAvatarColor(recipient.gender, context),
                      child: Text(
                        recipient.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // ✅ Badge compleanno
                    if (isBirthday)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cake,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
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
                              // ✅ Evidenzia nome se compleanno
                              color: isBirthday ? Theme.of(context).colorScheme.primary : null,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($age)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // ✅ Icona compleanno
                          if (isBirthday) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.celebration,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${genderMap[recipient.gender] ?? recipient.gender} · ${utils.DateUtils.formatDateIT(recipient.birthDate)}',
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
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error, // ✅ Uso del tema
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getAvatarColor(String gender, BuildContext context) {
    final theme = Theme.of(context);
    switch (gender) {
      case 'M':
        return theme.colorScheme.primary;
      case 'F':
        return theme.colorScheme.secondary;
      case 'NB':
        return theme.colorScheme.tertiary;
      case 'X':
        return theme.colorScheme.outline;
      case 'O':
      default:
        return theme.colorScheme.primaryContainer;
    }
  }
}