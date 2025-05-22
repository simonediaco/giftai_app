import 'package:dio/dio.dart';
import 'error_messages.dart';

class ApiError implements Exception {
  final String message;
  final String? technicalMessage; // ✅ Messaggio tecnico per debug
  final int? statusCode;
  final Map<String, dynamic>? data;

  ApiError({
    required this.message,
    this.technicalMessage,
    this.statusCode,
    this.data,
  });

  factory ApiError.fromDioError(DioException error) {
    int? statusCode = error.response?.statusCode;
    String technicalMessage = error.message ?? 'Unknown error';
    String userMessage = ErrorMessages.genericError;
    Map<String, dynamic>? data = error.response?.data is Map ? error.response?.data : null;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        userMessage = ErrorMessages.timeoutError;
        break;
        
      case DioExceptionType.badResponse:
        userMessage = ErrorMessages.getMessageByStatusCode(statusCode ?? 500);
        
        // ✅ Gestisci messaggi specifici dal backend se disponibili
        if (data != null && data['message'] != null) {
          final backendMessage = data['message'].toString();
          if (backendMessage.isNotEmpty && backendMessage.length < 100) {
            userMessage = backendMessage;
          }
        }
        break;
        
      case DioExceptionType.cancel:
        userMessage = 'La richiesta è stata annullata';
        break;
        
      case DioExceptionType.connectionError:
        userMessage = ErrorMessages.networkError;
        break;
        
      default:
        userMessage = ErrorMessages.getDisplayMessage(error.message ?? '');
        break;
    }

    return ApiError(
      message: userMessage,
      technicalMessage: technicalMessage,
      statusCode: statusCode,
      data: data,
    );
  }
  
  /// Factory per errori custom dell'app
  factory ApiError.custom(String message, {int? statusCode}) {
    return ApiError(
      message: message,
      statusCode: statusCode,
    );
  }
  
  /// Factory per errori di validazione
  factory ApiError.validation(String field, String message) {
    return ApiError(
      message: message,
      statusCode: 400,
      data: {'field': field, 'error': message},
    );
  }
  
  @override
  String toString() => message;
  
  /// Per il debugging - include dettagli tecnici
  String toDebugString() {
    return 'ApiError: $message'
           '${statusCode != null ? ' (Status: $statusCode)' : ''}'
           '${technicalMessage != null ? ' - Technical: $technicalMessage' : ''}';
  }
}