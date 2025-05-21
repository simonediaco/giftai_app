import 'package:flutter/material.dart';

/// Utility class for handling relationship translations between UI display and API values
class RelationshipTranslations {
  /// Maps UI display values to API values
  static Map<String, String> uiToApi = {
    'Amico': 'friend',
    'Familiare': 'family',
    'Partner': 'partner',
    'Collega': 'colleague',
    'Altro': 'other',
  };

  /// Maps API values to UI display values
  static Map<String, String> apiToUi = {
    'friend': 'Amico',
    'family': 'Familiare',
    'partner': 'Partner',
    'colleague': 'Collega',
    'other': 'Altro',
  };

  /// Converts a UI display value to its corresponding API value
  static String toApiValue(String uiValue) {
    return uiToApi[uiValue] ?? 'other';
  }

  /// Converts an API value to its corresponding UI display value
  static String toUiValue(String apiValue) {
    return apiToUi[apiValue] ?? 'Altro';
  }

  /// Returns a list of all UI display values for relationships
  static List<String> getAllUiValues() {
    return uiToApi.keys.toList();
  }
}

/// Utility class for handling category translations between UI display and API values
class CategoryTranslations {
  /// Maps UI display values to API values
  static Map<String, String> uiToApi = {
    'Moda': 'fashion',
    'Tech': 'tech',
    'Casa': 'home',
    'Sport': 'sports',
    'Libri': 'books',
    'Esperienze': 'experiences',
    'Bellezza': 'beauty',
    'Cibo e Bevande': 'food_drinks',
    'Altro': 'other',
  };

  /// Maps API values to UI display values
  static Map<String, String> apiToUi = {
    'fashion': 'Moda',
    'tech': 'Tech',
    'home': 'Casa',
    'sports': 'Sport',
    'books': 'Libri',
    'experiences': 'Esperienze',
    'beauty': 'Bellezza',
    'food_drinks': 'Cibo e Bevande',
    'other': 'Altro',
  };

  /// Converts a UI display value to its corresponding API value
  static String toApiValue(String uiValue) {
    return uiToApi[uiValue] ?? 'other';
  }

  /// Converts an API value to its corresponding UI display value
  static String toUiValue(String apiValue) {
    return apiToUi[apiValue] ?? 'Altro';
  }

  /// Returns a list of all UI display values for categories
  static List<String> getAllUiValues() {
    return uiToApi.keys.toList();
  }
}

/// Utility class for handling gender translations between UI display and API values
class GenderTranslations {
  /// Maps UI display values to API values
  static Map<String, String> uiToApi = {
    'Uomo': 'male',
    'Donna': 'female',
    'Non-binario': 'non_binary',
    'Preferisco non specificare': 'not_specified',
  };

  /// Maps API values to UI display values
  static Map<String, String> apiToUi = {
    'male': 'Uomo',
    'female': 'Donna',
    'non_binary': 'Non-binario',
    'not_specified': 'Preferisco non specificare',
  };

  /// Converts a UI display value to its corresponding API value
  static String toApiValue(String uiValue) {
    return uiToApi[uiValue] ?? 'not_specified';
  }

  /// Converts an API value to its corresponding UI display value
  static String toUiValue(String apiValue) {
    return apiToUi[apiValue] ?? 'Preferisco non specificare';
  }

  /// Returns a list of all UI display values for genders
  static List<String> getAllUiValues() {
    return uiToApi.keys.toList();
  }
}

/// Utility class for handling budget range translations between UI display and API values
class BudgetTranslations {
  /// Maps UI display values to API values
  static Map<String, String> uiToApi = {
    'Sotto 20€': '0-20',
    '20-50€': '20-50',
    '50-100€': '50-100',
    '100-200€': '100-200',
    'Sopra 200€': '200+',
  };

  /// Maps API values to UI display values
  static Map<String, String> apiToUi = {
    '0-20': 'Sotto 20€',
    '20-50': '20-50€',
    '50-100': '50-100€',
    '100-200': '100-200€',
    '200+': 'Sopra 200€',
  };

  /// Converts a UI display value to its corresponding API value
  static String toApiValue(String uiValue) {
    return uiToApi[uiValue] ?? '50-100';
  }

  /// Converts an API value to its corresponding UI display value
  static String toUiValue(String apiValue) {
    return apiToUi[apiValue] ?? '50-100€';
  }

  /// Returns a list of all UI display values for budget ranges
  static List<String> getAllUiValues() {
    return uiToApi.keys.toList();
  }
}