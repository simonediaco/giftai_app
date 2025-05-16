// lib/features/saved_gifts/data/models/saved_gift_model.dart
import '../../domain/entities/saved_gift.dart';

class SavedGiftModel extends SavedGift {
  const SavedGiftModel({
    required int id,
    required String name,
    required double price,
    required int match,
    String? image,
    required String category,
    required DateTime dateAdded,
    String? notes,
  }) : super(
          id: id,
          name: name,
          price: price,
          match: match,
          image: image,
          category: category,
          dateAdded: dateAdded,
          notes: notes,
        );

  factory SavedGiftModel.fromJson(Map<String, dynamic> json) {
    return SavedGiftModel(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int 
            ? (json['price'] as int).toDouble() 
            : json['price'],
      match: json['match'],
      image: json['image'],
      category: json['category'],
      dateAdded: DateTime.parse(json['date_added']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'match': match,
      'image': image,
      'category': category,
      'date_added': dateAdded.toIso8601String(),
      'notes': notes,
    };
  }
}