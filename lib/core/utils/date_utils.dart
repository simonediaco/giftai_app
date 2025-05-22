class DateUtils {
  /// Calcola l'età da una data di nascita
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    // Controlla se il compleanno è già passato quest'anno
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  /// Formatta una data in formato italiano (dd/MM/yyyy)
  static String formatDateIT(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
  
  /// Controlla se il compleanno è oggi
  static bool isBirthdayToday(DateTime birthDate) {
    final today = DateTime.now();
    return today.month == birthDate.month && today.day == birthDate.day;
  }
  
  /// Controlla se il compleanno è nei prossimi giorni
  static bool isBirthdayInDays(DateTime birthDate, int days) {
    final today = DateTime.now();
    final thisYearBirthday = DateTime(today.year, birthDate.month, birthDate.day);
    final nextYearBirthday = DateTime(today.year + 1, birthDate.month, birthDate.day);
    
    final targetBirthday = thisYearBirthday.isAfter(today) 
        ? thisYearBirthday 
        : nextYearBirthday;
    
    final difference = targetBirthday.difference(today).inDays;
    return difference >= 0 && difference <= days;
  }
}