import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/auth/auth_event.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthProfileRequested>(_onAuthProfileRequested);
    on<AuthProfileUpdateRequested>(_onAuthProfileUpdateRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getUserProfile();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.login(
        username: event.username,
        password: event.password,
      );
      
      if (success) {
        final user = await _authRepository.getUserProfile();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthFailure(message: 'Login fallito. Controlla le credenziali.'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.register(
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      
      if (success) {
        emit(AuthRegistrationSuccess());
      } else {
        emit(const AuthRegistrationFailure(message: 'Registrazione fallita.'));
      }
    } catch (e) {
      emit(AuthRegistrationFailure(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthProfileRequested(
    AuthProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getUserProfile();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthFailure(message: 'Impossibile caricare il profilo.'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onAuthProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final success = await _authRepository.updateUserProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        bio: event.bio,
        avatar: event.avatar,
        phoneNumber: event.phoneNumber,
      );
      
      if (success) {
        final user = await _authRepository.getUserProfile();
        if (user != null) {
          emit(AuthProfileUpdateSuccess(user: user));
        } else {
          emit(const AuthFailure(message: 'Profilo aggiornato ma impossibile caricarlo.'));
        }
      } else {
        emit(const AuthProfileUpdateFailure(message: 'Impossibile aggiornare il profilo.'));
      }
    } catch (e) {
      emit(AuthProfileUpdateFailure(message: e.toString()));
    }
  }
}