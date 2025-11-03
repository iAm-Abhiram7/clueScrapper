import 'package:equatable/equatable.dart';

/// Evidence entity representing a piece of forensic evidence
class Evidence extends Equatable {
  final String evidenceId;
  final String type; // 'weapon', 'biological', 'document', 'fingerprint'
  final String description;
  final String location;
  final double confidence; // 0.0 to 1.0
  final String significance;

  const Evidence({
    required this.evidenceId,
    required this.type,
    required this.description,
    required this.location,
    required this.confidence,
    required this.significance,
  });

  @override
  List<Object?> get props => [
    evidenceId,
    type,
    description,
    location,
    confidence,
    significance,
  ];

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'evidenceId': evidenceId,
      'type': type,
      'description': description,
      'location': location,
      'confidence': confidence,
      'significance': significance,
    };
  }

  /// Create from JSON map
  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      evidenceId: json['evidenceId'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      significance: json['significance'] as String,
    );
  }
}
