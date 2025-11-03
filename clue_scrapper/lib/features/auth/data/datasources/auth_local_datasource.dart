import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/services/hive_service.dart';
import '../../../../core/utils/id_generator.dart';
import '../models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Local data source for authentication operations
class AuthLocalDataSource {
  final HiveService hiveService;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSource({
    required this.hiveService,
    FlutterSecureStorage? secureStorage,
  }) : secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userBox = hiveService.userBox;
      final passwordHash = _hashPassword(password);

      // Find user by email
      final user = userBox.values.firstWhere(
        (user) => user.email == email,
        orElse: () => throw const AuthException('User not found'),
      );

      // Verify password
      if (user.passwordHash != passwordHash) {
        throw const AuthException('Invalid password');
      }

      // Save login state
      await secureStorage.write(
        key: StorageKeys.currentUserIdKey,
        value: user.userId,
      );
      await secureStorage.write(key: StorageKeys.isLoggedInKey, value: 'true');
      await secureStorage.write(
        key: StorageKeys.lastLoginKey,
        value: DateTime.now().toIso8601String(),
      );

      debugPrint('AuthLocalDataSource: User logged in - ${user.email}');
      return user;
    } catch (e) {
      debugPrint('AuthLocalDataSource: Login failed - $e');
      if (e is AuthException) rethrow;
      throw AuthException('Login failed', details: e.toString());
    }
  }

  /// Sign up new user
  Future<UserModel> signup({
    required String email,
    required String password,
  }) async {
    try {
      final userBox = hiveService.userBox;

      // Check if user already exists
      final existingUser = userBox.values.any((user) => user.email == email);
      if (existingUser) {
        throw const AuthException('Email already registered');
      }

      // Create new user
      final newUser = UserModel(
        userId: IdGenerator.generateUserId(),
        email: email,
        passwordHash: _hashPassword(password),
        createdAt: DateTime.now(),
      );

      // Save to database
      await userBox.put(newUser.userId, newUser);

      // Save login state
      await secureStorage.write(
        key: StorageKeys.currentUserIdKey,
        value: newUser.userId,
      );
      await secureStorage.write(key: StorageKeys.isLoggedInKey, value: 'true');
      await secureStorage.write(
        key: StorageKeys.lastLoginKey,
        value: DateTime.now().toIso8601String(),
      );

      debugPrint('AuthLocalDataSource: User signed up - ${newUser.email}');
      return newUser;
    } catch (e) {
      debugPrint('AuthLocalDataSource: Signup failed - $e');
      if (e is AuthException) rethrow;
      throw AuthException('Signup failed', details: e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: StorageKeys.currentUserIdKey);
      await secureStorage.write(key: StorageKeys.isLoggedInKey, value: 'false');
      debugPrint('AuthLocalDataSource: User logged out');
    } catch (e) {
      throw AuthException('Logout failed', details: e.toString());
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = await secureStorage.read(
        key: StorageKeys.currentUserIdKey,
      );
      if (userId == null) return null;

      final userBox = hiveService.userBox;
      return userBox.get(userId);
    } catch (e) {
      debugPrint('AuthLocalDataSource: Get current user failed - $e');
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await secureStorage.read(
        key: StorageKeys.isLoggedInKey,
      );
      return isLoggedIn == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Delete user account
  Future<void> deleteAccount(String userId) async {
    try {
      final userBox = hiveService.userBox;
      await userBox.delete(userId);
      await logout();
      debugPrint('AuthLocalDataSource: Account deleted - $userId');
    } catch (e) {
      throw AuthException('Failed to delete account', details: e.toString());
    }
  }
}
