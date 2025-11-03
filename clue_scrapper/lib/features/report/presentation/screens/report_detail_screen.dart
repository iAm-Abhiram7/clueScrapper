import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/services/pdf_service.dart';
import '../../../../shared/services/hive_service.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/evidence.dart';
import '../providers/report_provider.dart';
import '../../../chat/data/models/chat_model.dart';

/// Screen for viewing detailed forensic report
class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  Report? _report;
  ChatModel? _chat;
  List<Evidence> _evidenceList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  /// Safely get substring to avoid RangeError
  String _safeCaseId(String chatId, [int maxLength = 8]) {
    if (chatId.length <= maxLength) {
      return chatId;
    }
    return chatId.substring(0, maxLength);
  }

  Future<void> _loadReport() async {
    try {
      final reportProvider = context.read<ReportProvider>();

      final report = await reportProvider.getReportById(widget.reportId);

      if (report == null) {
        setState(() {
          _error = 'Report not found';
          _isLoading = false;
        });
        return;
      }

      // Load chat details from Hive
      final hiveService = HiveService();
      final chat = hiveService.chatBox.get(report.chatId);

      // Parse evidence list
      final evidenceList = <Evidence>[];
      try {
        final decoded = jsonDecode(report.evidenceList) as List;
        evidenceList.addAll(
          decoded.map((item) => Evidence.fromJson(item as Map<String, dynamic>)),
        );
      } catch (e) {
        debugPrint('Error parsing evidence: $e');
      }

      setState(() {
        _report = report;
        _chat = chat;
        _evidenceList = evidenceList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load report: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: appColors.background,
        appBar: AppBar(
          title: const Text('Loading Report...'),
          backgroundColor: appColors.background,
        ),
        body: const LoadingIndicator(message: 'Loading report...'),
      );
    }

    if (_error != null || _report == null) {
      return Scaffold(
        backgroundColor: appColors.background,
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: appColors.background,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: appColors.error),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Report not found',
                style: TextStyle(fontSize: 16, color: appColors.error),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: _buildAppBar(appColors),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Header Card
            _buildHeaderCard(appColors),
            const SizedBox(height: 16),

            // Case Summary Section
            if (_report!.summary.isNotEmpty)
              _buildSection(
                'Case Summary',
                Icons.summarize,
                _report!.summary,
                appColors,
              ),

            // Crime Scene Analysis Section
            if (_report!.crimeSceneAnalysis.isNotEmpty)
              _buildSection(
                'Crime Scene Analysis',
                Icons.landscape,
                _report!.crimeSceneAnalysis,
                appColors,
              ),

            // Evidence Catalog Section
            if (_evidenceList.isNotEmpty)
              _buildEvidenceCatalog(appColors),

            // Key Observations Section
            if (_report!.observations.isNotEmpty)
              _buildSection(
                'Key Observations',
                Icons.lightbulb_outline,
                _report!.observations,
                appColors,
              ),

            // Preliminary Findings Section
            if (_report!.preliminaryFindings.isNotEmpty)
              _buildSection(
                'Preliminary Findings',
                Icons.assignment_turned_in,
                _report!.preliminaryFindings,
                appColors,
              ),

            // Action Buttons
            const SizedBox(height: 24),
            _buildActionButtons(appColors),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColors appColors) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Forensic Report'),
          if (_chat != null)
            Text(
              'Case #${_safeCaseId(_chat!.chatId)}',
              style: TextStyle(
                fontSize: 12,
                color: appColors.graphite,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      backgroundColor: appColors.background,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareReport,
          tooltip: 'Share Report',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'pdf':
                _exportAsPdf();
                break;
              case 'preview':
                _previewPdf();
                break;
              case 'delete':
                _deleteReport();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'preview',
              child: Row(
                children: [
                  Icon(Icons.preview),
                  SizedBox(width: 12),
                  Text('Preview PDF'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'pdf',
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf),
                  SizedBox(width: 12),
                  Text('Export PDF'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Delete Report', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderCard(AppColors appColors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: appColors.indigoInk, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.darkCharcoal.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: appColors.indigoInk.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description,
                  color: appColors.indigoInk,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case #${_chat != null ? _safeCaseId(_chat!.chatId, 12) : "Unknown"}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: appColors.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM dd, yyyy • HH:mm').format(_report!.generatedAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: appColors.graphite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: appColors.lightSage.withOpacity(0.5)),
          const SizedBox(height: 16),
          _buildInfoRow('Crime Type', _report!.crimeType, appColors),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Evidence Items',
            '${_report!.evidenceCount}',
            appColors,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Images Analyzed',
            '${_chat?.imageCount ?? 0}',
            appColors,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appColors.lightSage.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: appColors.indigoInk,
                ),
                const SizedBox(width: 6),
                Text(
                  'Active Investigation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appColors.indigoInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColors appColors) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: appColors.graphite,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: appColors.darkCharcoal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    String content,
    AppColors appColors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: appColors.indigoInk, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: appColors.darkCharcoal,
                    ),
                  ),
                ],
              ),
              Divider(color: appColors.lightSage, height: 24),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: appColors.darkCharcoal,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceCatalog(AppColors appColors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory, color: appColors.indigoInk, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Evidence Catalog',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: appColors.darkCharcoal,
                    ),
                  ),
                ],
              ),
              Divider(color: appColors.lightSage, height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _evidenceList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final evidence = _evidenceList[index];
                  return _buildEvidenceCard(evidence, index + 1, appColors);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceCard(Evidence evidence, int index, AppColors appColors) {
    final confidencePercent = (evidence.confidence * 100).toInt();
    final confidenceColor = confidencePercent >= 80
        ? appColors.lightSage
        : confidencePercent >= 60
            ? appColors.mutedSand
            : appColors.graphite.withOpacity(0.5);

    IconData icon;
    Color iconColor;

    switch (evidence.type.toLowerCase()) {
      case 'weapon':
        icon = Icons.report_problem;
        iconColor = Colors.red;
        break;
      case 'biological':
        icon = Icons.science;
        iconColor = Colors.purple;
        break;
      case 'document':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'fingerprint':
        icon = Icons.fingerprint;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.help_outline;
        iconColor = appColors.graphite;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: appColors.lightSage.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evidence #$index - ${evidence.type}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appColors.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      evidence.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: appColors.graphite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Confidence: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: appColors.graphite,
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: evidence.confidence,
                  backgroundColor: appColors.graphite.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(confidenceColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$confidencePercent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: confidenceColor,
                ),
              ),
            ],
          ),
          if (evidence.significance.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Significance: ${evidence.significance}',
              style: TextStyle(
                fontSize: 12,
                color: appColors.graphite,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppColors appColors) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _previewPdf,
            icon: const Icon(Icons.preview),
            label: const Text('Preview PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.indigoInk,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _shareReport,
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: OutlinedButton.styleFrom(
              foregroundColor: appColors.indigoInk,
              side: BorderSide(color: appColors.indigoInk),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _previewPdf() async {
    if (_report == null || _chat == null) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Generating PDF preview...'),
            ],
          ),
        ),
      );

      final pdfService = PdfService();
      final pdfFile = await pdfService.generateReportPdf(
        _report!,
        _chat!,
        _evidenceList,
      );

      if (!mounted) return;
      Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (_) async => await pdfFile.readAsBytes(),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to preview PDF: $e')),
      );
    }
  }

  Future<void> _exportAsPdf() async {
    if (_report == null || _chat == null) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Exporting PDF...'),
            ],
          ),
        ),
      );

      final pdfService = PdfService();
      final pdfFile = await pdfService.generateReportPdf(
        _report!,
        _chat!,
        _evidenceList,
      );

      if (!mounted) return;
      Navigator.pop(context);

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: 'Forensic Report - Case ${_safeCaseId(_chat!.chatId)}',
        text: 'Forensic analysis report generated on ${DateFormat('MMM dd, yyyy').format(_report!.generatedAt)}',
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export PDF: $e')),
      );
    }
  }

  Future<void> _shareReport() async {
    await _exportAsPdf();
  }

  Future<void> _deleteReport() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final appColors = context.appColors;
        return AlertDialog(
          title: Text('Delete Report', style: TextStyle(color: appColors.darkCharcoal)),
          content: const Text(
            'Are you sure you want to delete this report? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ReportProvider>().deleteReport(widget.reportId);

        // Delete PDF file if exists
        if (_report?.pdfPath != null) {
          final pdfFile = File(_report!.pdfPath!);
          if (await pdfFile.exists()) {
            await pdfFile.delete();
          }
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete report: $e')),
          );
        }
      }
    }
  }
}
