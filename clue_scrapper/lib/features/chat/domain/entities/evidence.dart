import 'package:equatable/equatable.dart';

/// Evidence entity for domain layer
class Evidence extends Equatable {
  final String evidenceId;
  final String type; // weapon, biological, document, fingerprint, etc.
  final String description;
  final double confidence; // 0.0 to 1.0
  final String imageReference;

  const Evidence({
    required this.evidenceId,
    required this.type,
    required this.description,
    required this.confidence,
    required this.imageReference,
  });

  @override
  List<Object?> get props => [
    evidenceId,
    type,
    description,
    confidence,
    imageReference,
  ];

  Evidence copyWith({
    String? evidenceId,
    String? type,
    String? description,
    double? confidence,
    String? imageReference,
  }) {
    return Evidence(
      evidenceId: evidenceId ?? this.evidenceId,
      type: type ?? this.type,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      imageReference: imageReference ?? this.imageReference,
    );
  }

  /// Get confidence level as string
  String get confidenceLevel {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.5) return 'Medium';
    return 'Low';
  }

  @override
  String toString() => 'Evidence(type: $type, confidence: $confidence)';
}
