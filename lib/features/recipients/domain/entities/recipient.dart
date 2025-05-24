import 'package:equatable/equatable.dart';

class Recipient extends Equatable {
  final int id;
  final String name;
  final String gender;
  final DateTime birthDate;
  final String? relation;
  final List<String> interests;
  final String? notes;
  
  const Recipient({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.relation,
    this.interests = const [],
    this.notes, required List favoriteColors,
  });
  
  @override
  List<Object?> get props => [id, name, gender, birthDate, relation, interests, notes];
}