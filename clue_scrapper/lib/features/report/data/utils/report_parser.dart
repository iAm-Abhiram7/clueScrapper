import '../../domain/entities/evidence.dart';

/// Parser for AI-generated forensic reports
class ReportParser {
  /// Parse the AI response into structured sections
  static Map<String, String> parseReport(String aiResponse) {
    final sections = <String, String>{};

    // Define section headers to look for
    final sectionHeaders = [
      'CASE SUMMARY',
      'CRIME SCENE ANALYSIS',
      'EVIDENCE CATALOG',
      'KEY OBSERVATIONS',
      'PRELIMINARY FINDINGS',
      'EVIDENCE SUMMARY',
    ];

    // Split by lines
    final lines = aiResponse.split('\n');
    String? currentSection;
    final sectionContent = <String, List<String>>{};

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Check if this line is a section header
      bool foundHeader = false;
      for (final header in sectionHeaders) {
        if (trimmedLine.contains(header) && trimmedLine.length < 100) {
          currentSection = header;
          sectionContent[currentSection] = [];
          foundHeader = true;
          break;
        }
      }

      // If not a header and we have a current section, add to content
      if (!foundHeader && currentSection != null && trimmedLine.isNotEmpty) {
        // Skip lines that are just asterisks or dashes
        if (!RegExp(r'^[\*\-_=]+$').hasMatch(trimmedLine)) {
          sectionContent[currentSection]!.add(trimmedLine);
        }
      }
    }

    // Convert lists to strings
    for (final header in sectionHeaders) {
      if (sectionContent.containsKey(header)) {
        sections[header] = sectionContent[header]!.join('\n').trim();
      }
    }

    return sections;
  }

  /// Extract evidence items from the EVIDENCE CATALOG section
  static List<Evidence> extractEvidenceItems(String reportText) {
    final evidenceList = <Evidence>[];

    try {
      // Try to find the EVIDENCE CATALOG section
      final sections = parseReport(reportText);
      final catalogSection = sections['EVIDENCE CATALOG'] ?? '';

      if (catalogSection.isEmpty) {
        return evidenceList;
      }

      // Parse evidence items
      final lines = catalogSection.split('\n');
      String? currentEvidenceId;
      String? currentType;
      String? currentDescription;
      String? currentLocation;
      double? currentConfidence;
      String? currentSignificance;

      for (final line in lines) {
        final trimmedLine = line.trim();

        // Evidence ID pattern: "Evidence ID", "Evidence #1", etc.
        if (trimmedLine.contains(
          RegExp(r'Evidence\s+(ID|#|Number)', caseSensitive: false),
        )) {
          // Save previous evidence if exists
          if (currentEvidenceId != null) {
            evidenceList.add(
              Evidence(
                evidenceId: currentEvidenceId,
                type: currentType ?? 'unknown',
                description: currentDescription ?? '',
                location: currentLocation ?? 'unknown',
                confidence: currentConfidence ?? 0.5,
                significance: currentSignificance ?? '',
              ),
            );
          }

          // Start new evidence
          currentEvidenceId = _extractValue(trimmedLine);
          currentType = null;
          currentDescription = null;
          currentLocation = null;
          currentConfidence = null;
          currentSignificance = null;
        }
        // Type pattern
        else if (trimmedLine.contains(RegExp(r'Type:', caseSensitive: false))) {
          currentType = _extractValue(trimmedLine);
        }
        // Description pattern
        else if (trimmedLine.contains(
          RegExp(r'Description:', caseSensitive: false),
        )) {
          currentDescription = _extractValue(trimmedLine);
        }
        // Location pattern
        else if (trimmedLine.contains(
          RegExp(r'Location:', caseSensitive: false),
        )) {
          currentLocation = _extractValue(trimmedLine);
        }
        // Confidence pattern
        else if (trimmedLine.contains(
          RegExp(r'Confidence:', caseSensitive: false),
        )) {
          final confidenceStr = _extractValue(trimmedLine);
          currentConfidence = _parseConfidence(confidenceStr);
        }
        // Significance pattern
        else if (trimmedLine.contains(
          RegExp(r'(Significance|Forensic)', caseSensitive: false),
        )) {
          currentSignificance = _extractValue(trimmedLine);
        }
      }

      // Add the last evidence item
      if (currentEvidenceId != null) {
        evidenceList.add(
          Evidence(
            evidenceId: currentEvidenceId,
            type: currentType ?? 'unknown',
            description: currentDescription ?? '',
            location: currentLocation ?? 'unknown',
            confidence: currentConfidence ?? 0.5,
            significance: currentSignificance ?? '',
          ),
        );
      }

      // If no evidence found using structured parsing, try alternative method
      if (evidenceList.isEmpty) {
        evidenceList.addAll(_extractEvidenceAlternative(catalogSection));
      }
    } catch (e) {
      print('Error parsing evidence: $e');
    }

    return evidenceList;
  }

  /// Extract value after colon in a line
  static String _extractValue(String line) {
    if (line.contains(':')) {
      return line.split(':').skip(1).join(':').trim();
    }
    return line.trim();
  }

  /// Parse confidence value from string (handles percentages and decimals)
  static double _parseConfidence(String confidenceStr) {
    try {
      // Remove any non-numeric characters except . and %
      final numStr = confidenceStr.replaceAll(RegExp(r'[^\d.]'), '');
      final value = double.parse(numStr);

      // If value is > 1, assume it's a percentage
      if (value > 1) {
        return value / 100.0;
      }
      return value;
    } catch (e) {
      return 0.5; // Default confidence
    }
  }

  /// Alternative evidence extraction method (less structured)
  static List<Evidence> _extractEvidenceAlternative(String catalogSection) {
    final evidenceList = <Evidence>[];

    // Split into potential evidence blocks
    final blocks = catalogSection.split(RegExp(r'\n\s*\n'));

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i].trim();
      if (block.isEmpty) continue;

      // Try to extract basic info from the block
      final lines = block.split('\n');
      if (lines.length >= 2) {
        evidenceList.add(
          Evidence(
            evidenceId: 'E${i + 1}',
            type: _guessEvidenceType(block),
            description: lines.first.trim(),
            location: 'See report',
            confidence: 0.7,
            significance: lines.length > 1 ? lines[1].trim() : '',
          ),
        );
      }
    }

    return evidenceList;
  }

  /// Guess evidence type from content
  static String _guessEvidenceType(String content) {
    final lower = content.toLowerCase();

    if (lower.contains(RegExp(r'weapon|knife|gun|firearm|blade'))) {
      return 'weapon';
    } else if (lower.contains(RegExp(r'blood|dna|tissue|fluid|biological'))) {
      return 'biological';
    } else if (lower.contains(RegExp(r'document|paper|note|letter|file'))) {
      return 'document';
    } else if (lower.contains(RegExp(r'fingerprint|print|impression'))) {
      return 'fingerprint';
    }

    return 'other';
  }

  /// Extract crime type from case summary
  static String extractCrimeType(String summary) {
    final lower = summary.toLowerCase();

    if (lower.contains('homicide') || lower.contains('murder')) {
      return 'Homicide';
    } else if (lower.contains('assault')) {
      return 'Assault';
    } else if (lower.contains('burglary') || lower.contains('break')) {
      return 'Burglary';
    } else if (lower.contains('robbery') || lower.contains('theft')) {
      return 'Robbery';
    } else if (lower.contains('arson') || lower.contains('fire')) {
      return 'Arson';
    } else if (lower.contains('fraud')) {
      return 'Fraud';
    } else if (lower.contains('vandalism')) {
      return 'Vandalism';
    }

    return 'Under Investigation';
  }
}
