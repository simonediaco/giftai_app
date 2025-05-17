import '../../domain/entities/recipient.dart';

class RecipientModel extends Recipient {
  const RecipientModel({
    required int id,
    required String name,
    required String gender,
    required DateTime birthDate,
    String? relation,
    List<String> interests = const [],
    String? notes,
  }) : super(
          id: id,
          name: name,
          gender: gender,
          birthDate: birthDate,
          relation: relation,
          interests: interests,
          notes: notes,
        );

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    return RecipientModel(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birth_date']),
      relation: json['relation'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : [],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
     // 'birth_date': birthDate.toIso8601String(), // Formato ISO 8601
      'birth_date': "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
      'relation': relation,
      'interests': interests,
      'notes': notes,
    };
  }
}