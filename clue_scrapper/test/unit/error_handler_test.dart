import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/core/errors/app_exceptions.dart';
import 'package:clue_scrapper/core/errors/error_handler.dart';

void main() {
  group('Error Handler Tests', () {
    test('NetworkException returns network error message', () {
      const exception = NetworkException('Connection failed');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('internet connection'));
    });

    test('AuthException returns auth error message', () {
      const exception = AuthException('Invalid credentials');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('Authentication'));
    });

    test('StorageException returns storage error message', () {
      const exception = StorageException('Save failed');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('save data'));
    });

    test('AIException returns AI error message', () {
      const exception = AIException('API limit reached');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('AI service'));
    });

    test('ValidationException returns validation message', () {
      const exception = ValidationException('Email is invalid');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, 'Email is invalid');
    });

    test('NotFoundException returns not found message', () {
      const exception = NotFoundException('User not found');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('not found'));
    });

    test('PermissionException returns permission message', () {
      const exception = PermissionException('Camera access denied');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('Permission'));
    });

    test('Unknown exception returns generic message', () {
      final exception = Exception('Unknown error');
      final message = ErrorHandler.getUserFriendlyMessage(exception);
      
      expect(message, contains('Something went wrong'));
    });
  });

  group('App Exception Tests', () {
    test('NetworkException has correct properties', () {
      const exception = NetworkException(
        'Connection failed',
        code: 'NET_001',
        details: {'timeout': 30},
      );
      
      expect(exception.message, 'Connection failed');
      expect(exception.code, 'NET_001');
      expect(exception.details, isNotNull);
    });

    test('Exception toString includes message', () {
      const exception = AuthException('Login failed', code: 'AUTH_001');
      final string = exception.toString();
      
      expect(string, contains('Login failed'));
      expect(string, contains('AUTH_001'));
    });
  });
}
