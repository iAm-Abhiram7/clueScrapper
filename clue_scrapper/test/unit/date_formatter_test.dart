import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/core/utils/date_formatter.dart';

void main() {
  group('Date Formatter Tests', () {
    test('Format date time to string', () {
      final dateTime = DateTime(2024, 11, 3, 14, 30, 0);
      final formatted = DateFormatter.formatDateTime(dateTime);
      
      expect(formatted, isNotEmpty);
      expect(formatted, contains('Nov'));
      expect(formatted, contains('3'));
      expect(formatted, contains('2024'));
    });

    test('Format date only', () {
      final dateTime = DateTime(2024, 11, 3);
      final formatted = DateFormatter.formatDate(dateTime);
      
      expect(formatted, isNotEmpty);
      expect(formatted, contains('Nov'));
    });

    test('Format time only', () {
      final dateTime = DateTime(2024, 11, 3, 14, 30, 0);
      final formatted = DateFormatter.formatTime(dateTime);
      
      expect(formatted, isNotEmpty);
      expect(formatted, contains(':'));
    });

    test('Format relative time - just now', () {
      final now = DateTime.now();
      final formatted = DateFormatter.formatRelative(now);
      
      expect(formatted, 'Just now');
    });

    test('Format relative time - minutes ago', () {
      final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      final formatted = DateFormatter.formatRelative(fiveMinutesAgo);
      
      expect(formatted, '5 min ago');
    });

    test('Format relative time - hours ago', () {
      final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2));
      final formatted = DateFormatter.formatRelative(twoHoursAgo);
      
      expect(formatted, '2 hours ago');
    });

    test('Format relative time - days ago', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final formatted = DateFormatter.formatRelative(threeDaysAgo);
      
      expect(formatted, contains('days ago'));
    });
  });
}
