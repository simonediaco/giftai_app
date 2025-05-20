import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/blocs/recipient/recipient_bloc.dart';
import 'package:giftai/blocs/recipient/recipient_event.dart';
import 'package:giftai/blocs/recipient/recipient_state.dart';
import 'package:giftai/screens/history/history_screen.dart';
import 'package:giftai/screens/profile/profile_screen.dart';
import 'package:giftai/screens/recipient/recipient_detail_screen.dart';
import 'package:giftai/screens/recipient/recipient_form_screen.dart';
import 'package:giftai/screens/saved/saved_gifts_screen.dart';
import 'package:giftai/screens/wizard/wizard_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/widgets/home/recipient_card.dart';
import 'package:giftai/widgets/home/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('home_screen');
    
    // Carica i destinatari quando la schermata si apre
    context.read<RecipientBloc>().add(RecipientFetchRequested());
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 0) {
      context.read<RecipientBloc>().add(RecipientFetchRequested());
    }
  }
  
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const WizardScreen(isEmbedded: true);
      case 2:
        return const SavedGiftsScreen();
      case 3:
        return const HistoryScreen();
      default:
        return _buildHomeTab();
    }
  }
  
  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecipientBloc>().add(RecipientFetchRequested());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sezione profilo
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated && state.user != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: state.user!.profile?.avatar != null
                              ? NetworkImage(state.user!.profile!.avatar!)
                              : null,
                          child: state.user!.profile?.avatar == null
                              ? Text(
                                  state.user!.firstName.isNotEmpty
                                      ? state.user!.firstName[0]
                                      : state.user!.username[0],
                                  style: const TextStyle(fontSize: 24),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ciao, ${state.user!.firstName.isNotEmpty ? state.user!.firstName : state.user!.username}!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Bentornato nella tua app di idee regalo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Statistiche
            const Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Destinatari',
                    value: '5',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Regali Salvati',
                    value: '12',
                    icon: Icons.card_giftcard,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Titolo sezione destinatari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'I tuoi destinatari',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipientFormScreen(),
                      ),
                    );
                  },
                  child: const Text('Aggiungi'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Lista destinatari
            BlocBuilder<RecipientBloc, RecipientState>(
              builder: (context, state) {
                if (state is RecipientLoading && state is! RecipientLoadSuccess) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is RecipientLoadFailure) {
                  return Center(
                    child: Text(
                      'Errore nel caricamento: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                if (state is RecipientLoadSuccess) {
                  if (state.recipients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nessun destinatario',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aggiungi i tuoi amici e familiari per generare idee regalo perfette per loro',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecipientFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Aggiungi destinatario'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.recipients.length,
                    itemBuilder: (context, index) {
                      final recipient = state.recipients[index];
                      return RecipientCard(
                        recipient: recipient,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipientDetailScreen(
                                recipientId: recipient.id!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Promozione del wizard
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trova subito una idea regalo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Usa il nostro assistente per generare idee regalo personalizzate in pochi passaggi',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: const Text('Inizia ora'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GiftAI'),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: implementare la ricerca
              },
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Genera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Salvati',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Cronologia',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipientFormScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}