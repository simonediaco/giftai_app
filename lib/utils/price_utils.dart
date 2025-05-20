import 'package:intl/intl.dart';

class PriceUtils {
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'it_IT',
      symbol: '€',
      decimalDigits: 2,
    );
    
    return formatter.format(price);
  }
  
  static String formatBudgetRange(String budget) {
    // Esempio formato input: "50-100€"
    if (budget.contains('-')) {
      final parts = budget.replaceAll('€', '').trim().split('-');
      if (parts.length == 2) {
        final min = double.tryParse(parts[0].trim());
        final max = double.tryParse(parts[1].trim());
        
        if (min != null && max != null) {
          final formatter = NumberFormat.currency(
            locale: 'it_IT',
            symbol: '€',
            decimalDigits: 0,
          );
          
          return '${formatter.format(min)} - ${formatter.format(max)}';
        }
      }
    }
    
    return budget;
  }
}