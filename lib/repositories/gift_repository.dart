import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/gift_model.dart';
import '../models/recipient_model.dart';
import '../utils/translations.dart';

/// Repository responsible for gift-related API calls and data handling
class GiftRepository {
  final Dio _dio;

  GiftRepository(this._dio);

  /// Generates gift ideas based on recipient details without saving the recipient
  /// 
  /// Takes [name], [age], [gender], [relation], [interests], [category], and [budget]
  /// Returns a list of [Gift] objects
  Future<List<Gift>> generateGiftIdeas({
    String? name,
    dynamic age, // Può essere String? o int?
    String? gender,
    required String relation,
    required List<String> interests,
    required String category,
    required String budget,
  }) async {
    try {
      // Converti i valori dell'UI in valori API
      final String apiRelation = RelationshipTranslations.toApiValue(relation);
      final String apiCategory = CategoryTranslations.toApiValue(category);
      final String apiBudget = BudgetTranslations.toApiValue(budget);
      final String? apiGender = gender != null ? GenderTranslations.toApiValue(gender) : null;
      
      // Gestisci il parametro age che può essere String o int
      String? apiAge;
      if (age != null) {
        apiAge = age is int ? age.toString() : age as String;
      }

      // Prepara i dati della richiesta esattamente come nella collezione Postman
      final Map<String, dynamic> data = {
        'name': name ?? '',
        'age': apiAge,
        'relation': apiRelation,  // Questo sarà ad esempio 'friend' invece di 'Amico'
        'interests': interests,
        'category': apiCategory,  // Questo sarà ad esempio 'tech' invece di 'Tech'
        'budget': apiBudget,      // Questo sarà ad esempio '50-100' invece di '50-100€'
      };

      // Aggiungi il genere solo se fornito
      if (apiGender != null) {
        data['gender'] = apiGender;
      }

      // Rimuovi i valori null
      data.removeWhere((key, value) => value == null);

      // Log dei dati della richiesta per debug
      print('Generate gift ideas request data: $data');

      // Effettua la richiesta API
      final response = await _dio.post('/api/generate-gift-ideas/', data: data);

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((giftJson) => Gift.fromJson(giftJson)).toList();
      } else {
        throw Exception('Failed to generate gift ideas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response!.data}');
        print('Response headers: ${e.response!.headers}');
        print('Response status code: ${e.response!.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to generate gift ideas: $e');
    }
  }

  /// Generates gift ideas for a saved recipient
  /// 
  /// Takes [recipientId], [category], and [budget]
  /// Returns a list of [Gift] objects
  Future<List<Gift>> generateGiftIdeasForRecipient({
    required int recipientId,
    required String category,
    required String budget,
  }) async {
    try {
      // Convert UI values to API values
      final String apiCategory = CategoryTranslations.toApiValue(category);
      final String apiBudget = BudgetTranslations.toApiValue(budget);

      // Prepare request data
      final Map<String, dynamic> data = {
        'category': apiCategory,
        'budget': apiBudget,
      };

      // Make API request
      final response = await _dio.post(
        '/api/generate-gift-ideas/recipient/$recipientId/',
        data: data,
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((giftJson) => Gift.fromJson(giftJson)).toList();
      } else {
        throw Exception('Failed to generate gift ideas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response!.data}');
        print('Response headers: ${e.response!.headers}');
        print('Response status code: ${e.response!.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to generate gift ideas: $e');
    }
  }

  /// Saves a gift idea to the user's saved gifts list
  /// 
  /// Takes a [Gift] object and an optional [recipientId]
  /// Returns the updated [Gift] with server-assigned ID
  Future<Gift> saveGift(Gift gift, {int? recipientId}) async {
    try {
      final Map<String, dynamic> data = gift.toJson();
      
      // Add recipient ID if provided
      if (recipientId != null) {
        data['recipient'] = recipientId;
      }

      final response = await _dio.post('/api/saved-gifts/', data: data);

      if (response.statusCode == 201) {
        return Gift.fromJson(response.data);
      } else {
        throw Exception('Failed to save gift: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to save gift: $e');
    }
  }

  /// Gets a list of saved gifts for the current user
  /// 
  /// Returns a list of [Gift] objects
  Future<List<Gift>> getSavedGifts() async {
    try {
      final response = await _dio.get('/api/saved-gifts/');

      if (response.statusCode == 200) {
        final results = response.data as List;
        return results.map((giftJson) => Gift.fromJson(giftJson)).toList();
      } else {
        throw Exception('Failed to fetch saved gifts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch saved gifts: $e');
    }
  }

  /// Gets details for a specific saved gift
  /// 
  /// Takes a [giftId]
  /// Returns the detailed [Gift] object
  Future<Gift> getSavedGiftById(int giftId) async {
    try {
      final response = await _dio.get('/api/saved-gifts/$giftId/');

      if (response.statusCode == 200) {
        return Gift.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch gift details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch gift details: $e');
    }
  }

  /// Deletes a saved gift
  /// 
  /// Takes a [giftId]
  /// Returns true if deletion was successful
  Future<bool> deleteSavedGift(int giftId) async {
    try {
      final response = await _dio.delete('/api/saved-gifts/$giftId/');

      return response.statusCode == 204;
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to delete gift: $e');
    }
  }

  /// Updates a saved gift
  /// 
  /// Takes a [giftId] and a map of [updates]
  /// Returns the updated [Gift]
  Future<Gift> updateSavedGift(int giftId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/api/saved-gifts/$giftId/', data: updates);

      if (response.statusCode == 200) {
        return Gift.fromJson(response.data);
      } else {
        throw Exception('Failed to update gift: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to update gift: $e');
    }
  }
}