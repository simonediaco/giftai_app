class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final UserProfile? profile;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile': profile?.toJson(),
    };
  }
}

class UserProfile {
  final String? bio;
  final String? avatar;
  final String? phoneNumber;

  UserProfile({
    this.bio,
    this.avatar,
    this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      avatar: json['avatar'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'avatar': avatar,
      'phone_number': phoneNumber,
    };
  }
}