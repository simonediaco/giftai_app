import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
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
    const SavedGiftsPage(),
    const ProfilePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Destinatari',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: 'Salvati',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profilo',
              ),
            ],
          ),
        ),
      ),
      // FAB contestuale a seconda della pagina
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
  
  Widget? _buildFloatingActionButton() {
    // Mostra FAB solo in certe pagine
    switch (_currentIndex) {
      case 0: // Home
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const GiftWizardPage(),
            ));
          },
          child: const Icon(Icons.card_giftcard),
          tooltip: 'Trova regalo',
        );
      case 1: // Destinatari
        // Usiamo già il FAB nella pagina Destinatari
        return null;
      default:
        return null;
    }
  }
}