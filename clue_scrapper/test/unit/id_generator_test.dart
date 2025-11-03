import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/core/utils/id_generator.dart';

void main() {
  group('ID Generator Tests', () {
    test('generateChatId generates valid UUID', () {
      final id = IdGenerator.generateChatId();
      
      expect(id, isNotEmpty);
      expect(id.length, 36); // UUID v4 length with dashes
      expect(id.contains('-'), true);
    });

    test('generateChatId generates unique IDs', () {
      final id1 = IdGenerator.generateChatId();
      final id2 = IdGenerator.generateChatId();
      
      expect(id1, isNot(equals(id2)));
    });

    test('generateReportId generates valid UUID', () {
      final id = IdGenerator.generateReportId();
      
      expect(id, isNotEmpty);
      expect(id.length, 36);
    });

    test('generateUserId generates valid UUID', () {
      final id = IdGenerator.generateUserId();
      
      expect(id, isNotEmpty);
      expect(id.length, 36);
    });

    test('Multiple calls generate different IDs', () {
      final ids = List.generate(100, (_) => IdGenerator.generateChatId());
      final uniqueIds = ids.toSet();
      
      expect(uniqueIds.length, 100); // All IDs should be unique
    });
  });
}
