import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart'; // ✅ Aggiunto
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart'; // ✅ Aggiunto
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/recipients/presentation/pages/recipients_page.dart'; 
import '../../features/gift_ideas/presentation/pages/gift_wizard_page.dart';
import '../../features/saved_gifts/presentation/pages/saved_gifts_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class MainLayout extends StatefulWidget {
  static const routeName = '/main';
  final int initialTabIndex;

  const MainLayout({
    Key? key, 
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }
  
  final List<Widget> _pages = [
    const HomePage(),
    const RecipientsPage(),
    const GiftWizardPage(),
    const SavedGiftsPage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // ✅ Naviga al login quando l'utente fa logout
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false, // Rimuovi tutto lo stack di navigazione
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Donatello'),
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              // Notifiche
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined),
                    // Badge per notifiche non lette (opzionale)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        // child: Text('3', style: TextStyle(fontSize: 8)), // Numero notifiche
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO: Navigare alle notifiche
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifiche - Coming soon!')),
                  );
                },
              ),
              
              // Profilo utente
              if (authState is Authenticated)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PopupMenuButton<String>(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        authState.user.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'profile':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                          break;
                        case 'settings':
                          // TODO: Navigare alle impostazioni
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Impostazioni - Coming soon!')),
                          );
                          break;
                        case 'logout':
                          // ✅ IMPLEMENTATO: Logout funzionante
                          _showLogoutDialog(context);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, 
                                 color: Theme.of(context).colorScheme.onSurface),
                            const SizedBox(width: 8),
                            const Text('Profilo'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined, 
                                 color: Theme.of(context).colorScheme.onSurface),
                            const SizedBox(width: 8),
                            const Text('Impostazioni'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, 
                                 color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: 8),
                            Text('Esci', 
                                 style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                showUnselectedLabels: true,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 22),
                    activeIcon: Icon(Icons.home_rounded, size: 22),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline, size: 22),
                    activeIcon: Icon(Icons.people_rounded, size: 22),
                    label: 'Destinatari',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_awesome_outlined, size: 22), // ✨ Stelline!
                    activeIcon: Icon(Icons.auto_awesome, size: 22),
                    label: 'Genera',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border_outlined, size: 22),
                    activeIcon: Icon(Icons.favorite_rounded, size: 22),
                    label: 'Salvati',
                  ),
                ],
              ),
            ),
          ),
        );
      },
      ),
          );
  }
  
  // ✅ Dialog di conferma logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma Logout'),
        content: const Text('Sei sicuro di voler uscire dall\'app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Chiudi dialog
              context.read<AuthBloc>().add(LogoutRequested()); // Esegui logout
            },
            child: const Text('Esci'),
          ),
        ],
      ),
    );
  }
}