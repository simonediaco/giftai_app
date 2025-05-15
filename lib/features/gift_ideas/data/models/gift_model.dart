import '../../domain/entities/gift.dart';

class GiftModel extends Gift {
  const GiftModel({
    required int id,
    required String name,
    required double price,
    required int match,
    String? image,
    required String category,
  }) : super(
          id: id,
          name: name,
          price: price,
          match: match,
          image: image,
          category: category,
        );

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      name: json['name'],
      price: json['price'] is int 
            ? (json['price'] as int).toDouble() 
            : json['price'],
      match: json['match'],
      image: json['image'],
      category: json['category'],
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
    };
  }
}