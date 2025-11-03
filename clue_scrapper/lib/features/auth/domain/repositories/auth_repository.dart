import '../entities/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login user with email and password
  Future<User> login({required String email, required String password});

  /// Sign up new user
  Future<User> signup({required String email, required String password});

  /// Logout current user
  Future<void> logout();

  /// Get current logged in user
  Future<User?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Delete user account
  Future<void> deleteAccount(String userId);
}
