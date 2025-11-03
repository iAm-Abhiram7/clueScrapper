import 'package:hive/hive.dart';
import '../../domain/entities/evidence.dart';

part 'evidence_model.g.dart';

/// Evidence model with Hive annotations for local storage
@HiveType(typeId: 3)
class EvidenceModel extends HiveObject {
  @HiveField(0)
  final String evidenceId;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double confidence;

  @HiveField(4)
  final String imageReference;

  EvidenceModel({
    required this.evidenceId,
    required this.type,
    required this.description,
    required this.confidence,
    required this.imageReference,
  });

  /// Convert to domain entity
  Evidence toEntity() {
    return Evidence(
      evidenceId: evidenceId,
      type: type,
      description: description,
      confidence: confidence,
      imageReference: imageReference,
    );
  }

  /// Create from domain entity
  factory EvidenceModel.fromEntity(Evidence evidence) {
    return EvidenceModel(
      evidenceId: evidence.evidenceId,
      type: evidence.type,
      description: evidence.description,
      confidence: evidence.confidence,
      imageReference: evidence.imageReference,
    );
  }

  /// Create a copy with modified fields
  EvidenceModel copyWith({
    String? evidenceId,
    String? type,
    String? description,
    double? confidence,
    String? imageReference,
  }) {
    return EvidenceModel(
      evidenceId: evidenceId ?? this.evidenceId,
      type: type ?? this.type,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      imageReference: imageReference ?? this.imageReference,
    );
  }

  @override
  String toString() => 'EvidenceModel(type: $type, confidence: $confidence)';
}
