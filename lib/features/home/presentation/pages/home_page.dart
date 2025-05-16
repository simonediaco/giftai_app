// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';
import '../../../../shared/widgets/app_button.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header personalizzato
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spaceL),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Saluto
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                child: Text(
                                  state.user.name?.substring(0, 1).toUpperCase() ?? 'U',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppTheme.spaceM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ciao, ${state.user.name ?? 'Utente'}!',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Benvenuto in GiftAI',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined),
                                color: Colors.white,
                                onPressed: () {
                                  // TODO: Implementare notifiche
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spaceXL),
                          
                          // Call to action principale
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spaceL),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scopri il regalo perfetto',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spaceS),
                                Text(
                                  'Utilizziamo l\'intelligenza artificiale per trovare idee regalo personalizzate',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppTheme.spaceM),
                                AppButton(
                                  text: 'Inizia ora',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const GiftWizardPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.card_giftcard),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sezione statistiche
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Le tue statistiche',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spaceM),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  icon: Icons.search,
                                  title: '5',
                                  subtitle: 'Ricerche',
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spaceM),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  icon: Icons.favorite,
                                  title: '3',
                                  subtitle: 'Salvati',
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spaceM),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  icon: Icons.person,
                                  title: '2',
                                  subtitle: 'Destinatari',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sezione categorie popolari
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categorie popolari',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spaceM),
                          SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildCategoryCard(context, 'Tech', Icons.devices, Colors.blue),
                                _buildCategoryCard(context, 'Moda', Icons.shopping_bag, Colors.purple),
                                _buildCategoryCard(context, 'Casa', Icons.home, Colors.green),
                                _buildCategoryCard(context, 'Sport', Icons.sports_soccer, Colors.orange),
                                _buildCategoryCard(context, 'Hobby', Icons.palette, Colors.red),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sezione consigli e suggerimenti
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceL),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spaceL),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.purple.shade300,
                              Colors.purple.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.yellow),
                                const SizedBox(width: AppTheme.spaceS),
                                Text(
                                  'Suggerimento del giorno',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spaceM),
                            Text(
                              'Per un regalo più significativo, considera sempre gli interessi e le passioni della persona a cui stai facendo il regalo.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppTheme.spaceXS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.spaceM),
      width: 100,
      child: InkWell(
        onTap: () {
          // TODO: Navigare alla ricerca per categoria
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3),
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppTheme.spaceS),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}