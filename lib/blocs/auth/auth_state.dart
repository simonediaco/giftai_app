import 'package:equatable/equatable.dart';
import 'package:giftai/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel? user;

  const AuthAuthenticated({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthRegistrationSuccess extends AuthState {}

class AuthRegistrationFailure extends AuthState {
  final String message;

  const AuthRegistrationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthProfileUpdateSuccess extends AuthState {
  final UserModel user;

  const AuthProfileUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthProfileUpdateFailure extends AuthState {
  final String message;

  const AuthProfileUpdateFailure({required this.message});

  @override
  List<Object> get props => [message];
}