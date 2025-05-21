class Recipient {
  final int? id;
  final String name;
  final String? gender;
  final DateTime? birthDate;
  final int? age;
  final String relation;
  final List<String> interests;
  final List<String>? favoriteColors;
  final List<String>? dislikes;
  final String? notes;
  final DateTime? createdAt;

  Recipient({
    this.id,
    required this.name,
    this.gender,
    this.birthDate,
    this.age,
    required this.relation,
    required this.interests,
    this.favoriteColors,
    this.dislikes,
    this.notes,
    this.createdAt,
  });

  /// Crea un Recipient da JSON
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      age: json['age'],
      relation: json['relation'],
      interests: List<String>.from(json['interests'] ?? []),
      favoriteColors: json['favorite_colors'] != null
          ? List<String>.from(json['favorite_colors'])
          : null,
      dislikes:
          json['dislikes'] != null ? List<String>.from(json['dislikes']) : null,
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /// Converte il recipient in JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'age': age,
      'relation': relation,
      'interests': interests,
      'favorite_colors': favoriteColors,
      'dislikes': dislikes,
      'notes': notes,
    };

    if (id != null) data['id'] = id;
    if (gender != null) data['gender'] = gender;
    if (birthDate != null) data['birth_date'] = birthDate!.toIso8601String();
    if (relation != null) data['relation'] = relation;
    if (interests.isNotEmpty) data['interests'] = interests;
    if (favoriteColors != null) data['favorite_colors'] = favoriteColors;
    if (dislikes != null) data['dislikes'] = dislikes;
    if (notes != null) data['notes'] = notes;
    if (age != null) data['age'] = age;
    return data;
  }

  /// Crea una copia del recipient con valori aggiornati
  Recipient copyWith({
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
    DateTime? createdAt,
  }) {
    return Recipient(
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
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Ottiene l'iniziale del nome
  String get initial {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Formatta la data di creazione
  String get formattedCreationDate {
    if (createdAt == null) return '';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  @override
  String toString() {
    return 'Recipient(id: $id, name: $name, relation: $relation)';
  }
}