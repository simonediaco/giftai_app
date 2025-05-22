class ErrorMessages {
  // Errori di rete
  static const String networkError = 'Verifica la tua connessione internet e riprova';
  static const String serverError = 'I nostri server stanno avendo dei problemi. Riprova tra poco';
  static const String timeoutError = 'La richiesta sta impiegando troppo tempo. Riprova';
  
  // Errori di autenticazione
  static const String loginFailed = 'Email o password non corretti';
  static const String registrationFailed = 'Non è stato possibile creare l\'account. Riprova';
  static const String tokenExpired = 'La tua sessione è scaduta. Effettua di nuovo l\'accesso';
  static const String unauthorized = 'Non hai i permessi per accedere a questa funzione';
  
  // Errori di validazione
  static const String emailRequired = 'Inserisci la tua email';
  static const String emailInvalid = 'Inserisci un\'email valida';
  static const String passwordRequired = 'Inserisci la password';
  static const String passwordTooShort = 'La password deve contenere almeno 6 caratteri';
  static const String passwordMismatch = 'Le password non coincidono';
  static const String nameRequired = 'Inserisci il nome';
  
  // Errori regali e destinatari
  static const String giftGenerationFailed = 'Non siamo riusciti a generare idee regalo. Riprova';
  static const String recipientSaveFailed = 'Non è stato possibile salvare il destinatario';
  static const String recipientDeleteFailed = 'Non è stato possibile eliminare il destinatario';
  static const String giftSaveFailed = 'Non è stato possibile salvare il regalo';
  
  // Errori generici
  static const String genericError = 'Si è verificato un errore imprevisto';
  static const String dataLoadError = 'Non è stato possibile caricare i dati';
  
  /// Converte un errore tecnico in un messaggio user-friendly
  static String getDisplayMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('socket') || 
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return networkError;
    }
    
    if (errorString.contains('timeout')) {
      return timeoutError;
    }
    
    if (errorString.contains('server') || 
        errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503')) {
      return serverError;
    }
    
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return tokenExpired;
    }
    
    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return unauthorized;
    }
    
    if (errorString.contains('login') || errorString.contains('authentication')) {
      return loginFailed;
    }
    
    if (errorString.contains('register') || errorString.contains('registration')) {
      return registrationFailed;
    }
    
    if (errorString.contains('recipient')) {
      return recipientSaveFailed;
    }
    
    if (errorString.contains('gift')) {
      return giftGenerationFailed;
    }
    
    // Fallback per errori non categorizzati
    return genericError;
  }
  
  /// Ottiene un messaggio di errore basato sul codice di stato HTTP
  static String getMessageByStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'I dati inseriti non sono corretti';
      case 401:
        return tokenExpired;
      case 403:
        return unauthorized;
      case 404:
        return 'La risorsa richiesta non è stata trovata';
      case 408:
        return timeoutError;
      case 429:
        return 'Troppe richieste. Attendi un momento prima di riprovare';
      case 500:
      case 502:
      case 503:
        return serverError;
      default:
        return genericError;
    }
  }
}