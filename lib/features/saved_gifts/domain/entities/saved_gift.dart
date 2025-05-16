// lib/features/saved_gifts/domain/entities/saved_gift.dart
import 'package:equatable/equatable.dart';

class SavedGift extends Equatable {
  final int id;
  final String name;
  final double price;
  final int match;
  final String? image;
  final String category;
  final DateTime dateAdded;
  final String? notes;
  
  const SavedGift({
    required this.id,
    required this.name,
    required this.price,
    required this.match,
    this.image,
    required this.category,
    required this.dateAdded,
    this.notes,
  });
  
  @override
  List<Object?> get props => [id, name, price, match, image, category, dateAdded, notes];
}