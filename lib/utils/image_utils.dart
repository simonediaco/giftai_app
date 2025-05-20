import 'package:giftai/config/app_config.dart';

class ImageUtils {
  static String getImageForCategory(String category) {
    final map = {
      'tech': 'assets/images/tech.jpg',
      'casa': 'assets/images/casa.jpg',
      'moda': 'assets/images/moda.jpg',
      'esperienze': 'assets/images/esperienze.jpg',
      'sport': 'assets/images/sport.jpg',
      'bellezza': 'assets/images/bellezza.jpg',
    };
    return map[category.toLowerCase()] ?? 'assets/images/fallback.jpg';
  }

  static String getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    if (imagePath.startsWith('/')) {
      return '${AppConfig.apiBaseUrl}$imagePath';
    }
    
    return imagePath;
  }
}