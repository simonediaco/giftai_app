import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'config/app_theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiftAI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Segue le impostazioni del sistema
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      // Altre rotte potrebbero essere aggiunte qui se necessario
    );
  }
}