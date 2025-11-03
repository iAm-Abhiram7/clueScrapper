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

  @HiveField(7)
  final String fullContent;

  @HiveField(8)
  final String? pdfPath;

  @HiveField(9)
  final int evidenceCount;

  @HiveField(10)
  final String crimeSceneAnalysis;

  @HiveField(11)
  final String preliminaryFindings;

  ReportModel({
    required this.reportId,
    required this.chatId,
    required this.generatedAt,
    required this.summary,
    required this.evidenceList,
    required this.observations,
    required this.crimeType,
    required this.fullContent,
    this.pdfPath,
    this.evidenceCount = 0,
    this.crimeSceneAnalysis = '',
    this.preliminaryFindings = '',
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
      fullContent: fullContent,
      pdfPath: pdfPath,
      evidenceCount: evidenceCount,
      crimeSceneAnalysis: crimeSceneAnalysis,
      preliminaryFindings: preliminaryFindings,
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
      fullContent: report.fullContent,
      pdfPath: report.pdfPath,
      evidenceCount: report.evidenceCount,
      crimeSceneAnalysis: report.crimeSceneAnalysis,
      preliminaryFindings: report.preliminaryFindings,
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
    String? fullContent,
    String? pdfPath,
    int? evidenceCount,
    String? crimeSceneAnalysis,
    String? preliminaryFindings,
  }) {
    return ReportModel(
      reportId: reportId ?? this.reportId,
      chatId: chatId ?? this.chatId,
      generatedAt: generatedAt ?? this.generatedAt,
      summary: summary ?? this.summary,
      evidenceList: evidenceList ?? this.evidenceList,
      observations: observations ?? this.observations,
      crimeType: crimeType ?? this.crimeType,
      fullContent: fullContent ?? this.fullContent,
      pdfPath: pdfPath ?? this.pdfPath,
      evidenceCount: evidenceCount ?? this.evidenceCount,
      crimeSceneAnalysis: crimeSceneAnalysis ?? this.crimeSceneAnalysis,
      preliminaryFindings: preliminaryFindings ?? this.preliminaryFindings,
    );
  }

  @override
  String toString() =>
      'ReportModel(reportId: $reportId, crimeType: $crimeType)';
}
