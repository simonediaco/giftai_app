
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';
import '../../../../shared/widgets/app_button.dart';
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
  @override
  void initState() {
    super.initState();
    // Fetch recipients when page loads
    context.read<RecipientsBloc>().add(FetchRecipients());
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(''),
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

                  // Generate Gift Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceL),
                    child: Container(
                      width: double.infinity,
                      height: 56,
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
                          backgroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                          ),
                        ),
                        child: Text(
                          'Genera un Regalo',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceL),

                  // Recipients Quick Access
                  BlocBuilder<RecipientsBloc, RecipientsState>(
                    builder: (context, state) {
                      print('Recipients state: $state'); // Debug log

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
                        print('Recipients loaded: ${state.recipients.length}'); // Debug log
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
                                          builder: (context) => AlertDialog(
                                            title: Text('Conferma Dettagli'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Destinatario: ${recipient.name}'),
                                                const SizedBox(height: AppTheme.spaceXS),
                                                Text('Età: ${DateTime.now().year - recipient.birthDate.year}'),
                                                const SizedBox(height: AppTheme.spaceXS),
                                                Text('Interessi: ${recipient.interests.join(", ")}'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Modifica'),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => GiftWizardPage(
                                                        initialRecipient: recipient,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text('Conferma'),
                                              ),
                                            ],
                                          ),
                                        );
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
          ),
        ),
        title: Text(gift.name),
        subtitle: Text('\$${gift.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            // Open Amazon affiliate link
          },
        ),
      ),
    );
  }

  static final List<PopularGift> _popularGifts = [
    PopularGift(
      name: 'Wireless Earbuds',
      price: 129.99,
      imageUrl: 'https://m.media-amazon.com/images/I/51R8U4qEfAL._AC_SL1500_.jpg',
    ),
    PopularGift(
      name: 'Smart Watch',
      price: 199.99,
      imageUrl: 'https://m.media-amazon.com/images/I/815fRQwqbKL.__AC_SY445_SX342_QL70_ML2_.jpg',
    ),
    PopularGift(
      name: 'Portable Speaker',
      price: 79.99,
      imageUrl: 'https://m.media-amazon.com/images/I/71hwhYM7DiL.__AC_SX300_SY300_QL70_ML2_.jpg',
    ),
  ];
}

class PopularGift {
  final String name;
  final double price;
  final String imageUrl;

  PopularGift({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
