import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository _repository;
  
  Register(this._repository);
  
  Future<User> call({
    required String email,
    required String password,
    required String username,
    String? name,
  }) {
    return _repository.register(
      email: email,
      password: password,
      username: username,
      name: name,
    );
  }
}