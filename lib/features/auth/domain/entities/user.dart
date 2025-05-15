import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profileImage;
  final DateTime? dateJoined;
  
  const User({
    required this.id,
    required this.email,
    this.name,
    this.profileImage,
    this.dateJoined,
  });
  
  @override
  List<Object?> get props => [id, email, name, profileImage, dateJoined];
}