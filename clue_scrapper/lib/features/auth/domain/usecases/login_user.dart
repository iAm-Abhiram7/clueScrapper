import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call({required String email, required String password}) async {
    return await repository.login(email: email, password: password);
  }
}
