import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/core/utils/validators.dart';

void main() {
  group('Email Validator Tests', () {
    test('Valid email returns null', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('user.name@domain.co.uk'), null);
      expect(Validators.validateEmail('user+tag@example.com'), null);
    });

    test('Invalid email returns error message', () {
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('test@'), isNotNull);
      expect(Validators.validateEmail('@example.com'), isNotNull);
      expect(Validators.validateEmail('test@domain'), isNotNull);
    });

    test('Empty email returns error message', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('Email too long returns error message', () {
      final longEmail = '${'a' * 300}@example.com';
      expect(Validators.validateEmail(longEmail), isNotNull);
    });
  });

  group('Password Validator Tests', () {
    test('Valid password returns null', () {
      expect(Validators.validatePassword('Test@1234'), null);
      expect(Validators.validatePassword('MyP@ssw0rd'), null);
      expect(Validators.validatePassword('Secure#Pass123'), null);
    });

    test('Short password returns error', () {
      expect(Validators.validatePassword('Test@1'), isNotNull);
      expect(Validators.validatePassword('Ab1!'), isNotNull);
    });

    test('Password without uppercase returns error', () {
      expect(Validators.validatePassword('test@1234'), isNotNull);
      expect(Validators.validatePassword('password123!'), isNotNull);
    });

    test('Password without lowercase returns error', () {
      expect(Validators.validatePassword('TEST@1234'), isNotNull);
      expect(Validators.validatePassword('PASSWORD123!'), isNotNull);
    });

    test('Password without number returns error', () {
      expect(Validators.validatePassword('Test@Password'), isNotNull);
      expect(Validators.validatePassword('NoNumbers!'), isNotNull);
    });

    test('Password without special character returns error', () {
      expect(Validators.validatePassword('Test1234'), isNotNull);
      expect(Validators.validatePassword('Password123'), isNotNull);
    });

    test('Empty password returns error', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });
  });

  group('Confirm Password Validator Tests', () {
    test('Matching passwords return null', () {
      expect(Validators.validateConfirmPassword('Test@1234', 'Test@1234'), null);
    });

    test('Non-matching passwords return error', () {
      expect(Validators.validateConfirmPassword('Test@1234', 'Different@1234'), isNotNull);
    });

    test('Empty confirm password returns error', () {
      expect(Validators.validateConfirmPassword('', 'Test@1234'), isNotNull);
      expect(Validators.validateConfirmPassword(null, 'Test@1234'), isNotNull);
    });
  });

  group('Required Field Validator Tests', () {
    test('Non-empty value returns null', () {
      expect(Validators.validateRequired('value'), null);
    });

    test('Empty value returns error', () {
      expect(Validators.validateRequired(''), isNotNull);
      expect(Validators.validateRequired(null), isNotNull);
    });

    test('Custom field name in error message', () {
      final error = Validators.validateRequired('', fieldName: 'Username');
      expect(error, contains('Username'));
    });
  });

  group('Message Validator Tests', () {
    test('Valid message returns null', () {
      expect(Validators.validateMessage('Hello, this is a message'), null);
    });

    test('Empty message returns error', () {
      expect(Validators.validateMessage(''), isNotNull);
      expect(Validators.validateMessage(null), isNotNull);
    });

    test('Message too long returns error', () {
      final longMessage = 'a' * 10000; // Assuming max length < 10000
      expect(Validators.validateMessage(longMessage), isNotNull);
    });
  });

  group('Evidence Description Validator Tests', () {
    test('Valid description returns null', () {
      expect(Validators.validateEvidenceDescription('Detailed evidence description'), null);
    });

    test('Short description returns error', () {
      expect(Validators.validateEvidenceDescription('Short'), isNotNull);
    });

    test('Empty description returns error', () {
      expect(Validators.validateEvidenceDescription(''), isNotNull);
      expect(Validators.validateEvidenceDescription(null), isNotNull);
    });
  });
}
