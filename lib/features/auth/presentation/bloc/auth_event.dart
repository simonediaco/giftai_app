import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String? name;
  
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    this.name,
  });
  
  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}