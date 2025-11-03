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

  const Report({
    required this.reportId,
    required this.chatId,
    required this.generatedAt,
    required this.summary,
    required this.evidenceList,
    required this.observations,
    required this.crimeType,
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
  ];

  Report copyWith({
    String? reportId,
    String? chatId,
    DateTime? generatedAt,
    String? summary,
    String? evidenceList,
    String? observations,
    String? crimeType,
  }) {
    return Report(
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
  String toString() => 'Report(reportId: $reportId, crimeType: $crimeType)';
}
