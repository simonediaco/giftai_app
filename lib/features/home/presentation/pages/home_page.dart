import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
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

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipientsBloc>().add(FetchRecipients());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('GiftAI'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Handle notifications
                  },
                ),
                IconButton(
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      state.user.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to profile
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section with Image
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/img-home.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                theme.scaffoldBackgroundColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi ${state.user.name ?? ''}!',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Who would you like to gift today?',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Bottone "Genera un Regalo" evidenziato con sfumatura
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceL, vertical: AppTheme.spaceL),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GiftWizardPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Genera un Regalo',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceL),

                  // Recipients Quick Access
                  BlocBuilder<RecipientsBloc, RecipientsState>(
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
                            padding: EdgeInsets.all(AppTheme.spaceL),
                            child: Center(child: Text('Nessun destinatario trovato')),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(AppTheme.spaceL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'I tuoi destinatari',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spaceM),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.recipients.length,
                                  itemBuilder: (context, index) {
                                    final recipient = state.recipients[index];
                                    return _buildRecipientCard(
                                      context,
                                      name: recipient.name,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            String selectedCategory = 'Tech';
                                            double minPrice = 50;
                                            double maxPrice = 200;
                                            final categories = ['Tech', 'Moda', 'Sport', 'Casa', 'Libri'];
                                            
                                            return AlertDialog(
                                              title: Text('Genera Regalo per ${recipient.name}'),
                                              content: StatefulBuilder(
                                                builder: (context, setState) {

                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Recipient Info
                                                    Text('Età: ${_calculateAge(recipient.birthDate)}'),
                                                    const SizedBox(height: AppTheme.spaceXS),
                                                    Text('Interessi: ${recipient.interests.join(", ")}'),
                                                    const Divider(),
                                                    
                                                    // Category Selection
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
                                                    
                                                    // Price Range
                                                    Text('Budget:', style: theme.textTheme.titleSmall),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextFormField(
                                                            initialValue: minPrice.toString(),
                                                            keyboardType: TextInputType.number,
                                                            decoration: const InputDecoration(
                                                              labelText: 'Min €',
                                                            ),
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
                                                            decoration: const InputDecoration(
                                                              labelText: 'Max €',
                                                            ),
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
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/recipients',
                                                    arguments: recipient,
                                                  );
                                                },
                                                child: const Text('Modifica Destinatario'),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context.read<GiftIdeasBloc>().add(
                                                    GenerateGiftIdeasForRecipientRequested(
                                                      recipientId: recipient.id,
                                                      category: selectedCategory,
                                                      minPrice: minPrice.toInt(),
                                                      maxPrice: maxPrice.toInt(),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Genera Regalo'),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Popular Gifts
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Regali popolari',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceM),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _popularGifts.length,
                          itemBuilder: (context, index) {
                            final gift = _popularGifts[index];
                            return _buildGiftCard(context, gift);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRecipientCard(
    BuildContext context, {
    required String name,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: AppTheme.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text(name[0]),
              ),
              const SizedBox(height: AppTheme.spaceXS),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGiftCard(BuildContext context, PopularGift gift) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
          child: Image.network(
            gift.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(gift.name),
        subtitle: Text('\$${gift.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () async {
            if (gift.amazonUrl != null && await canLaunchUrl(Uri.parse(gift.amazonUrl!))) {
              await launchUrl(Uri.parse(gift.amazonUrl!));
            }
          },
        ),
      ),
    );
  }

  static int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static final List<PopularGift> _popularGifts = [
    PopularGift(
      name: 'Wireless Earbuds',
      price: 129.99,
      imageUrl: 'https://m.media-amazon.com/images/I/51R8U4qEfAL._AC_SL1500_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B07XJ8C8F5',
    ),
    PopularGift(
      name: 'Smart Watch',
      price: 199.99,
      imageUrl: 'https://m.media-amazon.com/images/I/815fRQwqbKL.__AC_SY445_SX342_QL70_ML2_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B09G6FPGTN',
    ),
    PopularGift(
      name: 'Portable Speaker',
      price: 79.99,
      imageUrl: 'https://m.media-amazon.com/images/I/71hwhYM7DiL.__AC_SX300_SY300_QL70_ML2_.jpg',
      amazonUrl: 'https://www.amazon.it/dp/B07QK2SPP7',
    ),
  ];
}

class PopularGift {
  final String name;
  final double price;
  final String imageUrl;
  final String? amazonUrl;

  PopularGift({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.amazonUrl,
  });
}