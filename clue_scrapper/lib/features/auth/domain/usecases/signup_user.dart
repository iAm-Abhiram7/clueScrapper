import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user signup
class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<User> call({required String email, required String password}) async {
    return await repository.signup(email: email, password: password);
  }
}
