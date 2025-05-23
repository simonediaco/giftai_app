// lib/features/gift_ideas/presentation/utils/gift_image_generator.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class GiftImageGenerator {
  // Mappa di icone per nome del regalo
  static final Map<String, IconData> _giftIconMap = {
    // Tech
    'cuffie': Icons.headphones,
    'auricolari': Icons.earbuds,
    'smartphone': Icons.smartphone,
    'tablet': Icons.tablet,
    'laptop': Icons.laptop,
    'smartwatch': Icons.watch,
    'speaker': Icons.speaker,
    'tastiera': Icons.keyboard,
    'mouse': Icons.mouse,
    'webcam': Icons.videocam,
    'monitor': Icons.monitor,
    'drone': Icons.flight,
    
    // Casa
    'lampada': Icons.light,
    'candela': Icons.local_fire_department,
    'pianta': Icons.local_florist,
    'cuscino': Icons.weekend,
    'tazza': Icons.coffee,
    'cornice': Icons.photo,
    'orologio': Icons.access_time,
    'vaso': Icons.yard,
    
    // Sport
    'yoga': Icons.self_improvement,
    'pesi': Icons.fitness_center,
    'borraccia': Icons.water_drop,
    'tappetino': Icons.sports_gymnastics,
    'scarpe': Icons.directions_run,
    'bicicletta': Icons.pedal_bike,
    'pallone': Icons.sports_soccer,
    
    // Libri
    'libro': Icons.book,
    'ebook': Icons.menu_book,
    'audiolibro': Icons.headphones,
    'fumetto': Icons.auto_stories,
    
    // Bellezza
    'profumo': Icons.spa,
    'trucco': Icons.brush,
    'crema': Icons.face_retouching_natural,
    'shampoo': Icons.shower,
    
    // Moda
    'borsa': Icons.shopping_bag,
    'scarpe': Icons.directions_walk,
    'occhiali': Icons.visibility,
    'orologio': Icons.watch,
    'sciarpa': Icons.dry_cleaning,
    'cappello': Icons.face,
    
    // Default per categoria
    '_default_tech': Icons.devices,
    '_default_casa': Icons.home,
    '_default_sport': Icons.sports,
    '_default_libri': Icons.menu_book,
    '_default_bellezza': Icons.face,
    '_default_moda': Icons.checkroom,
    '_default_hobby': Icons.palette,
    '_default_bambini': Icons.toys,
  };
  
  // Colori per categoria
  static final Map<String, List<Color>> _categoryColors = {
    'Tech': [Colors.blue, Colors.indigo, Colors.cyan],
    'Casa': [Colors.green, Colors.teal, Colors.lime],
    'Sport': [Colors.orange, Colors.deepOrange, Colors.red],
    'Libri': [Colors.brown, Colors.amber, Colors.orange],
    'Bellezza': [Colors.pink, Colors.purple, Colors.deepPurple],
    'Moda': [Colors.purple, Colors.indigo, Colors.pink],
    'Hobby': [Colors.teal, Colors.cyan, Colors.lightBlue],
    'Bambini': [Colors.red, Colors.yellow, Colors.green],
  };
  
  static IconData _getIconForGift(String giftName, String category) {
    final lowerName = giftName.toLowerCase();
    
    // Cerca parole chiave nel nome del regalo
    for (final entry in _giftIconMap.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Se non trova corrispondenza, usa l'icona default della categoria
    return _giftIconMap['_default_${category.toLowerCase()}'] ?? Icons.card_giftcard;
  }
  
  static List<Color> _getColorsForCategory(String category) {
    return _categoryColors[category] ?? [Colors.grey, Colors.blueGrey];
  }
  
  static Widget generateGiftImage({
    required String giftName,
    required String category,
    required double size,
  }) {
    final icon = _getIconForGift(giftName, category);
    final colors = _getColorsForCategory(category);
    final primaryColor = colors[giftName.hashCode % colors.length];
    final secondaryColor = colors[(giftName.hashCode + 1) % colors.length];
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.8),
            secondaryColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      ),
      child: Stack(
        children: [
          // Pattern di sfondo
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          // Icona centrale
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: size * 0.4,
                color: primaryColor,
              ),
            ),
          ),
          
          // Badge categoria
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter per pattern di sfondo
class _PatternPainter extends CustomPainter {
  final Color color;
  
  _PatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Disegna un pattern di cerchi
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}