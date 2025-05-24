import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/golden_accents.dart';
import '../../../../core/utils/date_utils.dart' as utils;
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../gift_ideas/presentation/bloc/gift_ideas_bloc.dart';
import '../../../gift_ideas/presentation/bloc/gift_ideas_event.dart';
import '../../../recipients/presentation/bloc/recipients_bloc.dart';
import '../../../recipients/presentation/bloc/recipients_event.dart';
import '../../../recipients/presentation/bloc/recipients_state.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroAnimation;
  
  @override
  void initState() {
    super.initState();
    context.read<RecipientsBloc>().add(FetchRecipients());
    
    // Animazione per il bottone principale
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _heroAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.elasticOut),
    );
    _heroController.forward();
  }
  
  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section migliorata con oro
                  _buildHeroSection(context, state.user.name ?? 'Utente'),
                  
                  // Quick Stats con oro
                  _buildQuickStats(context),
                  
                  // Recipients con compleanno evidenziato
                  _buildRecipientsSection(context),

                  // Sezione regali trending con accenti oro
                  _buildTrendingSection(context),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  
  // Hero Section con design migliorato e oro
  Widget _buildHeroSection(BuildContext context, String userName) {
    final theme = Theme.of(context);
    
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        // ✅ Aggiunta immagine di sfondo
        image: const DecorationImage(
          image: AssetImage('assets/images/img-home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // ✅ Overlay gradiente sopra l'immagine
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary.withValues(alpha: 0.7),
              GoldenAccents.primary.withValues(alpha: 0.4),
            ],
          ),
        ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              
              // Saluto con icona oro
              Row(
                children: [
                  // GoldenAccents.goldenIcon(
                  //   Icons.waving_hand,
                  //   size: 28,
                  //   withGlow: true,
                  // ),
                  // const SizedBox(width: AppTheme.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ciao $userName!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Trova il regalo perfetto oggi',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceXL),
              
              // Bottone principale animato con oro
              AnimatedBuilder(
                animation: _heroAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _heroAnimation.value,
                    child: GoldenAccents.premiumButton(
                      text: 'Genera Regalo',
                      icon: Icons.auto_awesome,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GiftWizardPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    ),
    );
  }
  
  // Quick Stats con elementi oro
  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceL),
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        border: Border.all(
          color: GoldenAccents.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: GoldenAccents.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.people,
              value: '5',
              label: 'Destinatari',
              color: theme.colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.emoji_events,
              value: '12',
              label: 'Perfect Match',
              color: GoldenAccents.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.favorite,
              value: '8',
              label: 'Salvati',
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: AppTheme.spaceS),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  // Recipients Section con evidenziazione compleanni
  Widget _buildRecipientsSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<RecipientsBloc, RecipientsState>(
      builder: (context, state) {
        if (state is RecipientsLoading) {
          return const Padding(
            padding: EdgeInsets.all(AppTheme.spaceL),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is RecipientsError) {
          return Padding(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            child: Center(child: Text('Errore: ${state.message}')),
          );
        }

        if (state is RecipientsLoaded) {
          if (state.recipients.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(AppTheme.spaceS),
              // child: Center(child: Text('Nessun destinatario trovato')),
            );
          }
          
          // Separa destinatari con compleanno da quelli normali
          final birthdayRecipients = state.recipients
              .where((r) => utils.DateUtils.isBirthdayToday(r.birthDate))
              .toList();
          final upcomingBirthdays = state.recipients
              .where((r) => utils.DateUtils.isBirthdayInDays(r.birthDate, 7) && !utils.DateUtils.isBirthdayToday(r.birthDate))
              .toList();
          
          return Padding(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sezione compleanni OGGI con oro
                if (birthdayRecipients.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: GoldenAccents.goldenBorder(withShadow: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GoldenAccents.goldenIcon(Icons.cake, withGlow: true),
                            const SizedBox(width: AppTheme.spaceS),
                            Text(
                              '🎉 Compleanni Oggi!',
                              style: GoldenAccents.goldenText(theme.textTheme.titleMedium!),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spaceM),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: birthdayRecipients.length,
                            itemBuilder: (context, index) {
                              final recipient = birthdayRecipients[index];
                              return _buildBirthdayRecipientCard(context, recipient);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceL),
                ],
                
                // Compleanni in arrivo (prossimi 7 giorni)
                if (upcomingBirthdays.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.upcoming, color: theme.colorScheme.primary),
                      const SizedBox(width: AppTheme.spaceS),
                      Text(
                        'Prossimi Compleanni',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingBirthdays.length,
                      itemBuilder: (context, index) {
                        final recipient = upcomingBirthdays[index];
                        return _buildUpcomingBirthdayCard(context, recipient);
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceL),
                ],
                
                // Tutti i destinatari
                Row(
                  children: [
                    Icon(Icons.people, color: theme.colorScheme.primary),
                    const SizedBox(width: AppTheme.spaceS),
                    Text(
                      'I tuoi Destinatari',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Naviga alla pagina destinatari
                      },
                      child: const Text('Vedi tutti'),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceM),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recipients.length,
                    itemBuilder: (context, index) {
                      final recipient = state.recipients[index];
                      return _buildRecipientCard(context, recipient);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
  
  // Card oro per compleanni oggi
  Widget _buildBirthdayRecipientCard(BuildContext context, recipient) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppTheme.spaceM),
      child: GoldenAccents.premiumBadge(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Text(
                  recipient.name[0],
                  style: const TextStyle(
                    color: GoldenAccents.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceXS),
              Text(
                recipient.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Card per compleanni in arrivo
  Widget _buildUpcomingBirthdayCard(BuildContext context, recipient) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final thisYearBirthday = DateTime(today.year, recipient.birthDate.month, recipient.birthDate.day);
    final nextYearBirthday = DateTime(today.year + 1, recipient.birthDate.month, recipient.birthDate.day);
    final targetBirthday = thisYearBirthday.isAfter(today) ? thisYearBirthday : nextYearBirthday;
    final daysUntil = targetBirthday.difference(today).inDays;
    
    return Card(
      margin: const EdgeInsets.only(right: AppTheme.spaceM),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(recipient.name[0]),
            ),
            const SizedBox(height: AppTheme.spaceXS),
            Text(
              recipient.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'tra $daysUntil giorni',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientCard(BuildContext context, recipient) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(right: AppTheme.spaceM),
      child: InkWell(
        onTap: () {
          _showGiftGenerationDialog(context, recipient);
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text(recipient.name[0]),
              ),
              const SizedBox(height: AppTheme.spaceXS),
              Text(
                recipient.name,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Sezione Trending con oro
  Widget _buildTrendingSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GoldenAccents.goldenIcon(Icons.trending_up, size: 28),
              const SizedBox(width: AppTheme.spaceS),
              Text(
                'Trending Regali',
                style: GoldenAccents.goldenText(theme.textTheme.titleMedium!),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
                  vertical: AppTheme.spaceXS,
                ),
                decoration: BoxDecoration(
                  gradient: GoldenAccents.goldSoftGradient,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                ),
                child: const Text(
                  'HOT 🔥',
                  style: TextStyle(
                    color: GoldenAccents.rich,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _trendingGifts.length,
            itemBuilder: (context, index) {
              final gift = _trendingGifts[index];
              return _buildTrendingGiftCard(context, gift);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendingGiftCard(BuildContext context, TrendingGift gift) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: ListTile(
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
              child: Image.network(
                gift.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surfaceVariant,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            // Badge trending oro
            if (gift.isTrending)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: GoldenAccents.goldGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.whatshot,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
        title: Text(gift.name),
        subtitle: Text('€${gift.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: GoldenAccents.goldenIcon(Icons.shopping_cart_outlined),
          onPressed: () async {
            if (gift.amazonUrl != null && await canLaunchUrl(Uri.parse(gift.amazonUrl!))) {
              await launchUrl(Uri.parse(gift.amazonUrl!));
            }
          },
        ),
      ),
    );
  }

  void _showGiftGenerationDialog(BuildContext context, recipient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Genera Regalo per ${recipient.name}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context); // ✅ FIXED: Aggiunta definizione theme
            String selectedCategory = 'Tech';
            double minPrice = 50;
            double maxPrice = 200;
            final categories = ['Tech', 'Moda', 'Sport', 'Casa', 'Libri'];
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Età: ${utils.DateUtils.calculateAge(recipient.birthDate)}'),
                const SizedBox(height: AppTheme.spaceXS),
                Text('Interessi: ${recipient.interests.join(", ")}'),
                const Divider(),
                
                Text('Categoria:', style: theme.textTheme.titleSmall),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: AppTheme.spaceM),
                
                Text('Budget:', style: theme.textTheme.titleSmall),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: minPrice.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Min €'),
                        onChanged: (value) {
                          setState(() {
                            minPrice = double.tryParse(value) ?? minPrice;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceM),
                    Expanded(
                      child: TextFormField(
                        initialValue: maxPrice.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Max €'),
                        onChanged: (value) {
                          setState(() {
                            maxPrice = double.tryParse(value) ?? maxPrice;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          Container(
            margin: const EdgeInsets.only(left: AppTheme.spaceS),
            child: GoldenAccents.premiumButton(
              text: 'Genera',
              icon: Icons.auto_awesome,
              onPressed: () {
                Navigator.pop(ctx);
                String selectedCategory = 'Tech';
                double minPrice = 50;
                double maxPrice = 200;
                context.read<GiftIdeasBloc>().add(
                  GenerateGiftIdeasForRecipientRequested(
                    recipientId: recipient.id,
                    category: selectedCategory,
                    minPrice: minPrice.toInt(),
                    maxPrice: maxPrice.toInt(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Mock data per trending gifts
  static final List<TrendingGift> _trendingGifts = [
    TrendingGift(
      name: 'AirPods Pro 2',
      price: 279.99,
      imageUrl: 'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B0BDHWDR12',
      isTrending: true,
    ),
    TrendingGift(
      name: 'MacBook Air M2',
      price: 1229.99,
      imageUrl: 'https://m.media-amazon.com/images/I/719C6bJv1eL._AC_SL1500_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B0B3C2R8MP',
      isTrending: true,
    ),
    TrendingGift(
      name: 'Nintendo Switch OLED',
      price: 349.99,
      imageUrl: 'https://m.media-amazon.com/images/I/61-PblYntsL._AC_SL1500_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B098RKWHHZ',
      isTrending: false,
    ),
  ];
}

class TrendingGift {
  final String name;
  final double price;
  final String imageUrl;
  final String? amazonUrl;
  final bool isTrending;

  TrendingGift({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.amazonUrl,
    this.isTrending = false,
  });
}