import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final int id;
  final String name;
  final double price;
  final int match;
  final String? image;
  final String category;
  
  const Gift({
    required this.id,
    required this.name,
    required this.price,
    required this.match,
    this.image,
    required this.category,
  });
  
  @override
  List<Object?> get props => [id, name, price, match, image, category];
}