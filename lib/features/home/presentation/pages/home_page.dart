import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/gift_ideas/presentation/pages/gift_generation_page.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../gift_ideas/presentation/pages/gift_wizard_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GiftAI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return Padding(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saluto
                  Text(
                    'Ciao, ${state.user.name ?? 'Utente'}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'Cosa vuoi fare oggi?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Card Generazione idee regalo
                  Card(
                    elevation: AppTheme.elevationM,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(GiftWizardPage.routeName);
                      },
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spaceL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.card_giftcard,
                              size: 48,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: AppTheme.spaceM),
                            Text(
                              'Genera Idee Regalo',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppTheme.spaceS),
                            Text(
                              'Trova il regalo perfetto per ogni occasione',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppTheme.spaceL),
                            AppButton(
                              text: 'Inizia',
                              onPressed: () {
                                Navigator.of(context).pushNamed(GiftWizardPage.routeName);
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}