import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;
  final String firstName;
  final String lastName;

  const AuthRegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [
    username,
    email,
    password,
    passwordConfirm,
    firstName,
    lastName,
  ];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthProfileRequested extends AuthEvent {}

class AuthProfileUpdateRequested extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? avatar;
  final String? phoneNumber;

  const AuthProfileUpdateRequested({
    this.firstName,
    this.lastName,
    this.bio,
    this.avatar,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [firstName, lastName, bio, avatar, phoneNumber];
}