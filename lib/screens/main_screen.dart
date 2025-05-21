import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/gift/gift_bloc.dart';
import '../blocs/gift/gift_event.dart';
import 'home/home_screen.dart';
import 'recipients/recipients_screen.dart';
import 'profile/profile_screen.dart';
import 'history/history_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const RecipientsScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Destinatari',
    'Cronologia',
    'Profilo',
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0) // Only show on home screen
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Clear any existing gift results
                // context.read<GiftBloc>().add(const ClearGiftResults());
              },
              tooltip: 'Ricomincia',
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}