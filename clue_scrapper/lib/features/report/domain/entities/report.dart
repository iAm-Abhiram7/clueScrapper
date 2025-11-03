import 'package:equatable/equatable.dart';

/// Report entity for domain layer
class Report extends Equatable {
  final String reportId;
  final String chatId;
  final DateTime generatedAt;
  final String summary;
  final String evidenceList; // JSON serialized list of evidence
  final String observations;
  final String crimeType;
  final String fullContent;
  final String? pdfPath;
  final int evidenceCount;
  final String crimeSceneAnalysis;
  final String preliminaryFindings;

  const Report({
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

  @override
  List<Object?> get props => [
        reportId,
        chatId,
        generatedAt,
        summary,
        evidenceList,
        observations,
        crimeType,
        fullContent,
        pdfPath,
        evidenceCount,
        crimeSceneAnalysis,
        preliminaryFindings,
      ];

  Report copyWith({
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
    return Report(
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
  String toString() => 'Report(reportId: $reportId, crimeType: $crimeType)';
}
