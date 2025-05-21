class User {
  final int? id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final DateTime? lastLogin;
  final DateTime? dateJoined;

  User({
    this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.lastLogin,
    this.dateJoined,
  });

  /// Crea un User da JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      dateJoined: json['date_joined'] != null ? DateTime.parse(json['date_joined']) : null,
    );
  }

  /// Converte il user in JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
    };

    if (id != null) data['id'] = id;
    if (email != null) data['email'] = email;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (profileImage != null) data['profile_image'] = profileImage;

    return data;
  }

  /// Crea una copia dell'utente con valori aggiornati
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImage,
    DateTime? lastLogin,
    DateTime? dateJoined,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      lastLogin: lastLogin ?? this.lastLogin,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }

  /// Ottiene il nome completo dell'utente
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return username;
    }
  }

  /// Ottiene le iniziali del nome
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    } else if (username.isNotEmpty) {
      return username[0].toUpperCase();
    } else {
      return 'U';
    }
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullName: $fullName)';
  }
}