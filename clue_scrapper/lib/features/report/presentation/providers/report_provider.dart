import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/report.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/utils/report_parser.dart';
import '../../../chat/data/models/chat_model.dart';
import '../../../chat/data/models/message_model.dart';
import '../../../../shared/services/gemini_service.dart';

/// Provider for managing report generation and state
class ReportProvider extends ChangeNotifier {
  final ReportRepositoryImpl _repository;
  final GeminiService _geminiService;

  bool _isGenerating = false;
  String? _error;
  List<Report> _reports = [];

  ReportProvider(this._repository, this._geminiService);

  bool get isGenerating => _isGenerating;
  String? get error => _error;
  List<Report> get reports => _reports;

  /// Load all reports
  Future<void> loadReports() async {
    try {
      _reports = await _repository.getAllReports();
      _reports.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load reports: $e';
      notifyListeners();
    }
  }

  /// Generate a comprehensive forensic report from chat conversation
  Future<String?> generateReport(
    String chatId,
    List<MessageModel> messages,
    ChatModel chat,
  ) async {
    try {
      debugPrint('ReportProvider: Starting report generation for chat $chatId');
      
      _isGenerating = true;
      _error = null;
      notifyListeners();

      // Convert MessageModel to Message entities for GeminiService
      debugPrint('ReportProvider: Converting ${messages.length} messages to entities');
      final messageEntities = messages.map((m) => m.toEntity()).toList();

      // Generate report content using AI
      debugPrint('ReportProvider: Calling Gemini API to generate report');
      final reportContent = await _geminiService.generateForensicReport(
        messageEntities,
        chatId,
        chat.imageCount,
      );
      
      debugPrint('ReportProvider: Report content generated, length: ${reportContent.length}');

      // Parse report sections
      debugPrint('ReportProvider: Parsing report sections');
      final sections = ReportParser.parseReport(reportContent);
      final evidenceList = ReportParser.extractEvidenceItems(reportContent);
      debugPrint('ReportProvider: Found ${evidenceList.length} evidence items');

      // Extract crime type
      final crimeType = ReportParser.extractCrimeType(
        sections['CASE SUMMARY'] ?? '',
      );
      debugPrint('ReportProvider: Crime type: $crimeType');

      // Create Report entity
      final reportId = const Uuid().v4();
      debugPrint('ReportProvider: Creating report entity with ID: $reportId');
      
      final report = Report(
        reportId: reportId,
        chatId: chatId,
        generatedAt: DateTime.now(),
        summary: sections['CASE SUMMARY'] ?? '',
        evidenceList: jsonEncode(evidenceList.map((e) => e.toJson()).toList()),
        observations: sections['KEY OBSERVATIONS'] ?? '',
        crimeType: crimeType,
        fullContent: reportContent,
        evidenceCount: evidenceList.length,
        crimeSceneAnalysis: sections['CRIME SCENE ANALYSIS'] ?? '',
        preliminaryFindings: sections['PRELIMINARY FINDINGS'] ?? '',
      );

      // Save to repository
      debugPrint('ReportProvider: Saving report to repository');
      await _repository.saveReport(report);

      // Reload reports
      debugPrint('ReportProvider: Reloading all reports');
      await loadReports();

      _isGenerating = false;
      notifyListeners();

      debugPrint('ReportProvider: Report generation completed successfully');
      return report.reportId;
    } catch (e, stackTrace) {
      debugPrint('ReportProvider: ERROR generating report - $e');
      debugPrint('ReportProvider: Stack trace - $stackTrace');
      
      _error = 'Failed to generate report: $e';
      _isGenerating = false;
      notifyListeners();
      rethrow; // Re-throw to allow caller to handle
    }
  }

  /// Get report by ID
  Future<Report?> getReportById(String reportId) async {
    return await _repository.getReportById(reportId);
  }

  /// Get report by chat ID
  Future<Report?> getReportByChatId(String chatId) async {
    return await _repository.getReportByChatId(chatId);
  }

  /// Check if a report exists for a chat
  Future<bool> hasReport(String chatId) async {
    return await _repository.hasReport(chatId);
  }

  /// Delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      await _repository.deleteReport(reportId);
      _reports.removeWhere((r) => r.reportId == reportId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete report: $e';
      notifyListeners();
    }
  }

  /// Update report with PDF path
  Future<void> updateReportPdfPath(String reportId, String pdfPath) async {
    try {
      final report = await _repository.getReportById(reportId);
      if (report != null) {
        final updatedReport = report.copyWith(pdfPath: pdfPath);
        await _repository.updateReport(updatedReport);
        await loadReports();
      }
    } catch (e) {
      _error = 'Failed to update report: $e';
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
