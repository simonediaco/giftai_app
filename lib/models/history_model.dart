import 'package:giftai/models/gift_model.dart';

class HistoryModel {
  final int id;
  final DateTime timestamp;
  final Map<String, dynamic> requestData;
  final List<GiftModel> results;

  HistoryModel({
    required this.id,
    required this.timestamp,
    required this.requestData,
    required this.results,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      requestData: json['request_data'],
      results: (json['results'] as List)
          .map((gift) => GiftModel.fromJson(gift))
          .toList(),
    );
  }
}