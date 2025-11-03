import 'package:hive/hive.dart';
import '../../domain/entities/report.dart';

part 'report_model.g.dart';

/// Report model with Hive annotations for local storage
@HiveType(typeId: 4)
class ReportModel extends HiveObject {
  @HiveField(0)
  final String reportId;

  @HiveField(1)
  final String chatId;

  @HiveField(2)
  final DateTime generatedAt;

  @HiveField(3)
  final String summary;

  @HiveField(4)
  final String evidenceList;

  @HiveField(5)
  final String observations;

  @HiveField(6)
  final String crimeType;

  ReportModel({
    required this.reportId,
    required this.chatId,
    required this.generatedAt,
    required this.summary,
    required this.evidenceList,
    required this.observations,
    required this.crimeType,
  });

  /// Convert to domain entity
  Report toEntity() {
    return Report(
      reportId: reportId,
      chatId: chatId,
      generatedAt: generatedAt,
      summary: summary,
      evidenceList: evidenceList,
      observations: observations,
      crimeType: crimeType,
    );
  }

  /// Create from domain entity
  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
      reportId: report.reportId,
      chatId: report.chatId,
      generatedAt: report.generatedAt,
      summary: report.summary,
      evidenceList: report.evidenceList,
      observations: report.observations,
      crimeType: report.crimeType,
    );
  }

  /// Create a copy with modified fields
  ReportModel copyWith({
    String? reportId,
    String? chatId,
    DateTime? generatedAt,
    String? summary,
    String? evidenceList,
    String? observations,
    String? crimeType,
  }) {
    return ReportModel(
      reportId: reportId ?? this.reportId,
      chatId: chatId ?? this.chatId,
      generatedAt: generatedAt ?? this.generatedAt,
      summary: summary ?? this.summary,
      evidenceList: evidenceList ?? this.evidenceList,
      observations: observations ?? this.observations,
      crimeType: crimeType ?? this.crimeType,
    );
  }

  @override
  String toString() =>
      'ReportModel(reportId: $reportId, crimeType: $crimeType)';
}
