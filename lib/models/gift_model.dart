import '../config/app_config.dart';

class GiftModel {
  final int? id;
  final String name;
  final double price;
  final int match;
  final String image;
  final String category;
  final String? description;
  final int? recipientId;
  final String? notes;

  GiftModel({
    this.id,
    required this.name,
    required this.price,
    required this.match,
    required this.image,
    required this.category,
    this.description,
    this.recipientId,
    this.notes,
  });

  String getFullImageUrl() {
    if (image.startsWith('http')) {
      return image;
    }
    return '${AppConfig.apiBaseUrl}$image';
  }

  String getAmazonUrl() {
    final encodedName = Uri.encodeComponent(name);
    return 'https://www.amazon.it/s?k=$encodedName&tag=${AppConfig.amazonAffiliateTag}';
  }

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int ? (json['price'] as int).toDouble() : json['price'],
      match: json['match'],
      image: json['image'],
      category: json['category'],
      description: json['description'],
      recipientId: json['recipient'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'price': price,
      'match': match,
      'image': image,
      'category': category,
      'description': description,
      'notes': notes,
    };

    if (id != null) {
      map['id'] = id;
    }
    
    if (recipientId != null) {
      map['recipient'] = recipientId;
    }

    return map;
  }
}