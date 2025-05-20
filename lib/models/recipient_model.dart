class RecipientModel {
  final int? id;
  final String name;
  final String gender;
  final DateTime? birthDate;
  final int? age;
  final String relation;
  final List<String> interests;
  final List<String> favoriteColors;
  final List<String> dislikes;
  final String? notes;

  RecipientModel({
    this.id,
    required this.name,
    required this.gender,
    this.birthDate,
    this.age,
    required this.relation,
    required this.interests,
    this.favoriteColors = const [],
    this.dislikes = const [],
    this.notes,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    return RecipientModel(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      age: json['age'],
      relation: json['relation'],
      interests: List<String>.from(json['interests'] ?? []),
      favoriteColors: List<String>.from(json['favorite_colors'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'gender': gender,
      'relation': relation,
      'interests': interests,
      'favorite_colors': favoriteColors,
      'dislikes': dislikes,
      'notes': notes,
    };

    if (id != null) {
      map['id'] = id;
    }
    
    if (birthDate != null) {
      map['birth_date'] = birthDate!.toIso8601String().split('T').first;
    }
    
    if (age != null) {
      map['age'] = age;
    }

    return map;
  }

  RecipientModel copyWith({
    int? id,
    String? name,
    String? gender,
    DateTime? birthDate,
    int? age,
    String? relation,
    List<String>? interests,
    List<String>? favoriteColors,
    List<String>? dislikes,
    String? notes,
  }) {
    return RecipientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      relation: relation ?? this.relation,
      interests: interests ?? this.interests,
      favoriteColors: favoriteColors ?? this.favoriteColors,
      dislikes: dislikes ?? this.dislikes,
      notes: notes ?? this.notes,
    );
  }
}