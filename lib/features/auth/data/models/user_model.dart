import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    String? name,
    String? profileImage,
    DateTime? dateJoined,
  }) : super(
          id: id,
          email: email,
          name: name,
          profileImage: profileImage,
          dateJoined: dateJoined,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      profileImage: json['profile_image'],
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image': profileImage,
      'date_joined': dateJoined?.toIso8601String(),
    };
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImage: user.profileImage,
      dateJoined: user.dateJoined,
    );
  }
}