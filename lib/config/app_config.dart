class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8000'; // Cambia con il tuo endpoint
  static const String amazonAffiliateTag = 'giftai-21'; // Il tuo tag di affiliazione
  
  // Timeout per le richieste API
  static const int connectionTimeout = 30000; // 30 secondi
  static const int receiveTimeout = 30000; // 30 secondi
  
  // Configurazione immagini
  static const String defaultImagePlaceholder = 'assets/images/placeholder.png';
  
  // Endpoint API
  static const String loginEndpoint = '/api/auth/token/';
  static const String registerEndpoint = '/api/auth/register/';
  static const String refreshTokenEndpoint = '/api/auth/token/refresh/';
  static const String userProfileEndpoint = '/api/users/me/';
  static const String recipientsEndpoint = '/api/recipients/';
  static const String generateGiftIdeasEndpoint = '/api/generate-gift-ideas/';
  static const String savedGiftsEndpoint = '/api/saved-gifts/';
  static const String historyEndpoint = '/api/history/';
}