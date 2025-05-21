/// Utility class for generating Amazon affiliate links
class AmazonAffiliateUtils {
  /// Your Amazon Associate ID
  static const String associateId = 'giftai-21';

  /// Base URL for Amazon.it
  static const String baseUrl = 'https://www.amazon.it';

  /// Generate an Amazon affiliate link for a product
  /// 
  /// Takes a [productName] and generates a search URL with affiliate ID
  static String generateAffiliateLink(String productName) {
    // Encode the product name for URL
    final encodedName = Uri.encodeComponent(productName);
    
    // Create the search URL with affiliate tag
    return '$baseUrl/s?k=$encodedName&tag=$associateId';
  }

  /// Generate a direct Amazon affiliate link for a product with an ASIN
  /// 
  /// Takes an [asin] (Amazon Standard Identification Number) and generates a direct product URL
  static String generateDirectProductLink(String asin) {
    return '$baseUrl/dp/$asin?tag=$associateId';
  }

  /// Generate a search URL for a category
  /// 
  /// Takes a [category] and generates a category search URL
  static String generateCategoryLink(String category) {
    // Map the category to Amazon category if needed
    String amazonCategory;
    switch (category.toLowerCase()) {
      case 'tech':
        amazonCategory = 'electronics';
        break;
      case 'fashion':
        amazonCategory = 'fashion';
        break;
      case 'books':
        amazonCategory = 'stripbooks';
        break;
      case 'sports':
        amazonCategory = 'sporting';
        break;
      case 'home':
        amazonCategory = 'garden';
        break;
      case 'beauty':
        amazonCategory = 'beauty';
        break;
      case 'food_drinks':
        amazonCategory = 'grocery';
        break;
      default:
        amazonCategory = 'aps';  // All departments
    }
    
    return '$baseUrl/s?i=$amazonCategory&tag=$associateId';
  }
}