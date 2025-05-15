import 'package:dio/dio.dart';

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;

  ApiError({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiError.fromDioError(DioException error) {
    int? statusCode = error.response?.statusCode;
    String message = 'Si è verificato un errore';
    Map<String, dynamic>? data = error.response?.data is Map ? error.response?.data : null;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'La connessione al server è scaduta';
        break;
      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            message = 'Richiesta non valida';
            break;
          case 401:
            message = 'Non autorizzato';
            break;
          case 403:
            message = 'Accesso negato';
            break;
          case 404:
            message = 'La risorsa richiesta non è disponibile';
            break;
          case 500:
            message = 'Errore interno del server';
            break;
          default:
            message = 'Si è verificato un errore (${statusCode})';
            break;
        }
        break;
      case DioExceptionType.cancel:
        message = 'La richiesta è stata annullata';
        break;
      case DioExceptionType.connectionError:
        message = 'Nessuna connessione internet';
        break;
      default:
        message = 'Si è verificato un errore imprevisto';
        break;
    }

    return ApiError(
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }
}