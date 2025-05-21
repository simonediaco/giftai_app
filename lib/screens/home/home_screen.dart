import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/gift/gift_bloc.dart';
import '../../blocs/gift/gift_event.dart';
import '../../models/gift_model.dart';
import '../../utils/amazon_affiliate_utils.dart';
import '../../widgets/gift_card.dart';
import '../gifts/gift_generation_wizard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Gift> _trendingGifts = [
    Gift(
      name: 'Cuffie Wireless Sony WH-1000XM4',
      price: 279.99,
      match: 95,
      category: 'Tech',
      description: 'Cuffie wireless con cancellazione del rumore attiva e autonomia fino a 30 ore',
      image: 'https://m.media-amazon.com/images/I/71oT1OaY9pL._AC_SL1500_.jpg',
    ),
    Gift(
      name: 'Nintendo Switch OLED',
      price: 349.99,
      match: 92,
      category: 'Tech',
      description: 'Console di gioco portatile con schermo OLED da 7 pollici',
      image: 'https://m.media-amazon.com/images/I/71NpmdIadmL._AC_SL1500_.jpg',
    ),
    Gift(
      name: 'Polaroid Now+ Fotocamera Istantanea',
      price: 149.99,
      match: 88,
      category: 'Tech',
      description: 'Fotocamera istantanea con connettività Bluetooth e filtri creativi',
      image: 'https://m.media-amazon.com/images/I/61BK8mMZ79L._AC_SL1500_.jpg',
    ),
    Gift(
      name: 'Crema Mani L\'Occitane',
      price: 24.99,
      match: 87,
      category: 'Bellezza',
      description: 'Set di creme mani nutrienti con burro di karité',
      image: 'https://m.media-amazon.com/images/I/71m1fWKXeUL._AC_SL1500_.jpg',
    ),
    Gift(
      name: 'Smartbox Fuga dalla Città',
      price: 99.90,
      match: 86,
      category: 'Esperienze',
      description: 'Cofanetto regalo per un weekend rilassante fuori città',
      image: 'https://m.media-amazon.com/images/I/71VU5M-WGFL._AC_SL1200_.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            _buildHeroSection(context),
            
            // Trending gifts section
            _buildTrendingGiftsSection(context),
            
            // Quick access section
            _buildQuickAccessSection(context),
            
            // Bottom padding
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GiftGenerationWizard(),
            ),
          );
        },
        child: const Icon(Icons.card_giftcard),
        tooltip: 'Genera idee regalo',
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Trova il regalo perfetto',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Rispondi a poche domande e trova l\'idea regalo ideale per ogni occasione',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GiftGenerationWizard(),
                ),
              );
            },
            icon: const Icon(Icons.card_giftcard),
            label: const Text('Inizia ora'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTrendingGiftsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'I più ricercati',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Azione per "Vedi tutti"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funzionalità in arrivo'),
                    ),
                  );
                },
                child: const Text('Vedi tutti'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _trendingGifts.length,
            itemBuilder: (context, index) {
              final gift = _trendingGifts[index];
              return _buildTrendingGiftCard(context, gift);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingGiftCard(BuildContext context, Gift gift) {
    // Genera un link Amazon affiliato
    final amazonUrl = AmazonAffiliateUtils.generateAffiliateLink(gift.name);

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine del prodotto
            AspectRatio(
              aspectRatio: 1,
              child: gift.image != null
                  ? Image.network(
                      gift.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.card_giftcard,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.card_giftcard,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
            ),
            
            // Dettagli del prodotto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome
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
                    
                    // Prezzo
                    Text(
                      gift.formattedPrice,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Pulsante Acquista su Amazon
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Apre il link Amazon (in una vera app useresti url_launcher)
                          _openAmazonLink(amazonUrl);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('Vedi su Amazon'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accesso rapido',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  icon: Icons.people,
                  title: 'Destinatari',
                  onTap: () {
                    // Naviga alla tab dei destinatari
                    // In un'app reale, useresti un NavigationService o un TabController
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  icon: Icons.category,
                  title: 'Categorie',
                  onTap: () {
                    // Azione per le categorie
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funzionalità in arrivo'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  icon: Icons.history,
                  title: 'Cronologia',
                  onTap: () {
                    // Naviga alla tab della cronologia
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  icon: Icons.help_outline,
                  title: 'Aiuto',
                  onTap: () {
                    // Azione per l'aiuto
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funzionalità in arrivo'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Apri un link (in una vera app utilizzeresti url_launcher)
  void _openAmazonLink(String url) {
    // In una vera app qui faresti:
    // launch(url);
    
    // Per adesso mostriamo solo un dialog
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