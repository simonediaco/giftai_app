import 'gift_model.dart';

class GiftGenerationResponse {
  final List<GiftModel> results;
  
  GiftGenerationResponse({
    required this.results,
  });
  
  factory GiftGenerationResponse.fromJson(Map<String, dynamic> json) {
    return GiftGenerationResponse(
      results: (json['results'] as List)
          .map((item) => GiftModel.fromJson(item))
          .toList(),
    );
  }
}