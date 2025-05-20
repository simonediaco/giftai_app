import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email obbligatoria';
    }
    
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Email non valida';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password obbligatoria';
    }
    
    if (value.length < 8) {
      return 'La password deve avere almeno 8 caratteri';
    }
    
    return null;
  }

  // Modifica qui per utilizzare correttamente FormFieldValidator
  static FormFieldValidator<String> required(String fieldName) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '$fieldName obbligatorio';
      }
      return null;
    };
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Conferma password obbligatoria';
    }
    
    if (value != password) {
      return 'Le password non corrispondono';
    }
    
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Età obbligatoria';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Età non valida';
    }
    
    if (age < 0 || age > 120) {
      return 'L\'età deve essere compresa tra 0 e 120';
    }
    
    return null;
  }
}