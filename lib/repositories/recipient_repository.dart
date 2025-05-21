import 'package:dio/dio.dart';

import '../models/recipient_model.dart';
import '../utils/translations.dart';

/// Repository for managing recipient data and API calls
class RecipientRepository {
  final Dio _dio;

  RecipientRepository(this._dio);

  /// Gets all recipients for the current user
  Future<List<Recipient>> getRecipients() async {
    try {
      final response = await _dio.get('/api/recipients/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          // Convert API values to UI values for display
          final rawJson = Map<String, dynamic>.from(json);
          
          // Convert relation from API to UI value
          if (rawJson.containsKey('relation')) {
            rawJson['relation'] = RelationshipTranslations.toUiValue(rawJson['relation']);
          }
          
          return Recipient.fromJson(rawJson);
        }).toList();
      } else {
        throw Exception('Failed to fetch recipients: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch recipients: $e');
    }
  }

  /// Gets a specific recipient by ID
  Future<Recipient> getRecipientById(int id) async {
    try {
      final response = await _dio.get('/api/recipients/$id/');

      if (response.statusCode == 200) {
        // Convert API values to UI values for display
        final rawJson = Map<String, dynamic>.from(response.data);
        
        // Convert relation from API to UI value
        if (rawJson.containsKey('relation')) {
          rawJson['relation'] = RelationshipTranslations.toUiValue(rawJson['relation']);
        }
        
        return Recipient.fromJson(rawJson);
      } else {
        throw Exception('Failed to fetch recipient: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch recipient: $e');
    }
  }
  
  /// Gets a specific recipient by ID (alias for getRecipientById)
  Future<Recipient> getRecipient(int id) async {
    return getRecipientById(id);
  }

  /// Creates a new recipient
  Future<Recipient> createRecipient(Recipient recipient) async {
    try {
      // Convert UI values to API values for sending
      final Map<String, dynamic> data = recipient.toJson();
      
      // Convert relation from UI to API value
      if (data.containsKey('relation')) {
        data['relation'] = RelationshipTranslations.toApiValue(data['relation']);
      }
      
      // Convert gender if present
      if (data.containsKey('gender') && data['gender'] != null) {
        data['gender'] = GenderTranslations.toApiValue(data['gender']);
      }

      final response = await _dio.post('/api/recipients/', data: data);

      if (response.statusCode == 201) {
        // Convert API values back to UI values for returning
        final rawJson = Map<String, dynamic>.from(response.data);
        
        // Convert relation from API to UI value
        if (rawJson.containsKey('relation')) {
          rawJson['relation'] = RelationshipTranslations.toUiValue(rawJson['relation']);
        }
        
        return Recipient.fromJson(rawJson);
      } else {
        throw Exception('Failed to create recipient: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to create recipient: $e');
    }
  }

  /// Updates an existing recipient
  Future<Recipient> updateRecipient(Recipient recipient) async {
    try {
      if (recipient.id == null) {
        throw Exception('Cannot update recipient without ID');
      }

      // Convert UI values to API values for sending
      final Map<String, dynamic> data = recipient.toJson();
      
      // Convert relation from UI to API value
      if (data.containsKey('relation')) {
        data['relation'] = RelationshipTranslations.toApiValue(data['relation']);
      }
      
      // Convert gender if present
      if (data.containsKey('gender') && data['gender'] != null) {
        data['gender'] = GenderTranslations.toApiValue(data['gender']);
      }

      final response =
          await _dio.put('/api/recipients/${recipient.id}/', data: data);

      if (response.statusCode == 200) {
        // Convert API values back to UI values for returning
        final rawJson = Map<String, dynamic>.from(response.data);
        
        // Convert relation from API to UI value
        if (rawJson.containsKey('relation')) {
          rawJson['relation'] = RelationshipTranslations.toUiValue(rawJson['relation']);
        }
        
        return Recipient.fromJson(rawJson);
      } else {
        throw Exception('Failed to update recipient: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to update recipient: $e');
    }
  }

  /// Deletes a recipient
  Future<bool> deleteRecipient(int id) async {
    try {
      final response = await _dio.delete('/api/recipients/$id/');
      return response.statusCode == 204;
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to delete recipient: $e');
    }
  }
}