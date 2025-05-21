import 'package:flutter/material.dart';
import '../../models/gift_model.dart';
import '../../utils/amazon_affiliate_utils.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Per ora usiamo dati statici, ma in una versione reale questi verrebbero da un repository
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      date: DateTime.now().subtract(const Duration(days: 2)),
      recipient: 'Marco',
      category: 'Tech',
      budget: '50-100€',
      gifts: [
        Gift(
          name: 'Cuffie Bluetooth',
          price: 79.99,
          match: 92,
          category: 'Tech',
          description: 'Cuffie wireless con cancellazione del rumore',
        ),
        Gift(
          name: 'Power bank 10000mAh',
          price: 39.99,
          match: 88,
          category: 'Tech',
          description: 'Caricabatterie portatile ad alta capacità',
        ),
      ],
    ),
    HistoryItem(
      date: DateTime.now().subtract(const Duration(days: 7)),
      recipient: 'Laura',
      category: 'Bellezza',
      budget: '20-50€',
      gifts: [
        Gift(
          name: 'Set Makeup L\'Oréal',
          price: 29.99,
          match: 95,
          category: 'Bellezza',
          description: 'Kit di trucchi completo per ogni occasione',
        ),
      ],
    ),
    HistoryItem(
      date: DateTime.now().subtract(const Duration(days: 14)),
      recipient: 'Carlo',
      category: 'Sport',
      budget: '100-200€',
      gifts: [
        Gift(
          name: 'Smartwatch Fitness',
          price: 149.99,
          match: 89,
          category: 'Tech',
          description: 'Orologio intelligente con monitoraggio attività fisica',
        ),
        Gift(
          name: 'Set abbigliamento running',
          price: 110.00,
          match: 85,
          category: 'Sport',
          description: 'Completo per la corsa con tecnologia traspirante',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_historyItems.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        title: 'Nessuna cronologia',
        message: 'Qui verranno visualizzate le tue ricerche precedenti di idee regalo', actionText: '', onActionPressed: () {  },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final item = _historyItems[index];
        return _buildHistoryCard(context, item);
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, HistoryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con data e destinatario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(item.date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Per ${item.recipient}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Dettagli della ricerca
            Row(
              children: [
                Icon(
                  Icons.category,
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  item.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.euro,
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  item.budget,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            
            const Divider(height: 24),
            
            // Lista regali suggeriti
            ...item.gifts.map((gift) => _buildGiftItem(context, gift)).toList(),
            
            // Pulsante per rigenerare
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Azione per rigenerare
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funzionalità in arrivo'),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Rigenera questi suggerimenti'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftItem(BuildContext context, Gift gift) {
    final amazonUrl = AmazonAffiliateUtils.generateAffiliateLink(gift.name);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicatore di match
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getMatchColor(gift.match).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${gift.match}%',
                style: TextStyle(
                  color: _getMatchColor(gift.match),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Dettagli regalo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gift.formattedPrice,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Apertura link amazon
                        _openAmazonLink(amazonUrl);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Vedi su Amazon'),
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

  Color _getMatchColor(int match) {
    if (match >= 90) {
      return Colors.green;
    } else if (match >= 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  void _openAmazonLink(String url) {
    // In una vera app useresti url_launcher
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link Amazon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('In una vera app, l\'URL verrebbe aperto nel browser:'),
            const SizedBox(height: 12),
            Text(url, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}

class HistoryItem {
  final DateTime date;
  final String recipient;
  final String category;
  final String budget;
  final List<Gift> gifts;

  HistoryItem({
    required this.date,
    required this.recipient,
    required this.category,
    required this.budget,
    required this.gifts,
  });
}