import 'package:hive/hive.dart';
import '../../domain/entities/report.dart';
import '../models/report_model.dart';

/// Implementation of report repository using Hive for local storage
class ReportRepositoryImpl {
  final Box<ReportModel> _reportBox;

  ReportRepositoryImpl(this._reportBox);

  /// Save a report to local storage
  Future<void> saveReport(Report report) async {
    try {
      final model = ReportModel.fromEntity(report);
      await _reportBox.put(report.reportId, model);
    } catch (e) {
      throw Exception('Failed to save report: $e');
    }
  }

  /// Get all reports
  Future<List<Report>> getAllReports() async {
    try {
      final models = _reportBox.values.toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  /// Get reports for a specific chat
  Future<Report?> getReportByChatId(String chatId) async {
    try {
      final model = _reportBox.values.firstWhere(
        (report) => report.chatId == chatId,
        orElse: () => throw Exception('Report not found'),
      );
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Get a report by its ID
  Future<Report?> getReportById(String reportId) async {
    try {
      final model = _reportBox.get(reportId);
      return model?.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      await _reportBox.delete(reportId);
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  /// Update a report
  Future<void> updateReport(Report report) async {
    try {
      final model = ReportModel.fromEntity(report);
      await _reportBox.put(report.reportId, model);
    } catch (e) {
      throw Exception('Failed to update report: $e');
    }
  }

  /// Check if a report exists for a chat
  Future<bool> hasReport(String chatId) async {
    try {
      return _reportBox.values.any((report) => report.chatId == chatId);
    } catch (e) {
      return false;
    }
  }
}
