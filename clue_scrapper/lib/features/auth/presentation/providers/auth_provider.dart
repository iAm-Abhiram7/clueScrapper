import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/errors/exceptions.dart';

/// State management for authentication using ChangeNotifier
class AuthProvider extends ChangeNotifier {
  final LoginUser loginUseCase;
  final SignupUser signupUseCase;
  final AuthRepositoryImpl repository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.repository,
  });

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Login user
  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await loginUseCase(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      debugPrint('AuthProvider: Login successful');
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      debugPrint('AuthProvider: Login failed - ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      debugPrint('AuthProvider: Login failed - $e');
      return false;
    }
  }

  /// Sign up user
  Future<bool> signup({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await signupUseCase(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      debugPrint('AuthProvider: Signup successful');
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      debugPrint('AuthProvider: Signup failed - ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      debugPrint('AuthProvider: Signup failed - $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await repository.logout();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
      debugPrint('AuthProvider: Logout successful');
    } catch (e) {
      debugPrint('AuthProvider: Logout failed - $e');
    }
  }

  /// Load current user (on app start)
  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await repository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('AuthProvider: Load current user failed - $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
