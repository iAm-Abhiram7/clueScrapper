import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../features/report/domain/entities/report.dart';
import '../../features/report/domain/entities/evidence.dart';
import '../../features/chat/data/models/chat_model.dart';

/// Service for generating PDF reports from forensic analysis data
class PdfService {
  /// Generate a professional PDF report from the forensic analysis
  Future<File> generateReportPdf(
    Report report,
    ChatModel chat,
    List<Evidence> evidenceList,
  ) async {
    final pdf = pw.Document();

    // Add pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Cover Page
            _buildCoverPage(report, chat, evidenceList.length),
            pw.SizedBox(height: 30),
            
            // Case Summary
            if (report.summary.isNotEmpty)
              _buildSection('CASE SUMMARY', report.summary),
            
            // Crime Scene Analysis
            if (report.crimeSceneAnalysis.isNotEmpty)
              _buildSection('CRIME SCENE ANALYSIS', report.crimeSceneAnalysis),
            
            // Evidence Catalog
            if (evidenceList.isNotEmpty)
              _buildEvidenceCatalog(evidenceList),
            
            // Key Observations
            if (report.observations.isNotEmpty)
              _buildSection('KEY OBSERVATIONS', report.observations),
            
            // Preliminary Findings
            if (report.preliminaryFindings.isNotEmpty)
              _buildSection('PRELIMINARY FINDINGS', report.preliminaryFindings),
          ];
        },
        footer: (context) => _buildFooter(report, context),
      ),
    );

    // Save PDF to file
    return await _savePdf(pdf, report.reportId);
  }

  /// Build the cover page of the report
  pw.Widget _buildCoverPage(Report report, ChatModel chat, int evidenceCount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(24),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xFF3E5C76), // Indigo Ink
          width: 3,
        ),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Title
          pw.Text(
            'FORENSIC ANALYSIS REPORT',
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF1D2D44), // Dark Charcoal
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            height: 3,
            width: 200,
            color: const PdfColor.fromInt(0xFF3E5C76), // Indigo Ink
          ),
          pw.SizedBox(height: 24),
          
          // Case Information
          _buildInfoRow('Case ID:', chat.chatId),
          pw.SizedBox(height: 12),
          _buildInfoRow('Crime Type:', report.crimeType),
          pw.SizedBox(height: 12),
          _buildInfoRow(
            'Generated:',
            DateFormat('MMMM dd, yyyy HH:mm').format(report.generatedAt),
          ),
          pw.SizedBox(height: 12),
          _buildInfoRow('Images Analyzed:', '${chat.imageCount}'),
          pw.SizedBox(height: 12),
          _buildInfoRow('Evidence Items:', '$evidenceCount'),
          pw.SizedBox(height: 12),
          _buildInfoRow('Chat Created:', DateFormat('MMM dd, yyyy').format(chat.createdAt)),
          
          pw.SizedBox(height: 24),
          
          // Status Badge
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFE8F0E3), // Light Sage tint
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              'Status: Active Investigation',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF3E5C76), // Indigo Ink
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an info row with label and value
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Container(
          width: 130,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF748386), // Graphite
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ),
      ],
    );
  }

  /// Build a section with title and content
  pw.Widget _buildSection(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        
        // Section Title
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF3E5C76), // Indigo Ink
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        
        pw.SizedBox(height: 12),
        
        // Section Content
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: const PdfColor.fromInt(0xFFB4C6A6), // Light Sage
              width: 1,
            ),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Text(
            content,
            style: const pw.TextStyle(
              fontSize: 12,
              lineSpacing: 1.5,
              color: PdfColors.black,
            ),
          ),
        ),
        
        pw.SizedBox(height: 12),
      ],
    );
  }

  /// Build the evidence catalog section with a table
  pw.Widget _buildEvidenceCatalog(List<Evidence> evidenceList) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        
        // Section Title
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF3E5C76), // Indigo Ink
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Text(
            'EVIDENCE CATALOG',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        
        pw.SizedBox(height: 12),
        
        // Evidence Table
        pw.Table(
          border: pw.TableBorder.all(
            color: const PdfColor.fromInt(0xFFB4C6A6), // Light Sage
            width: 1,
          ),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(3),
            3: const pw.FlexColumnWidth(1.5),
          },
          children: [
            // Header Row
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFB4C6A6), // Light Sage
              ),
              children: [
                _buildTableCell('ID', isHeader: true),
                _buildTableCell('Type', isHeader: true),
                _buildTableCell('Description', isHeader: true),
                _buildTableCell('Confidence', isHeader: true),
              ],
            ),
            
            // Evidence Rows
            ...evidenceList.map((evidence) {
              return pw.TableRow(
                children: [
                  _buildTableCell(_truncateText(evidence.evidenceId, 8)),
                  _buildTableCell(evidence.type),
                  _buildTableCell(evidence.description, maxLines: 3),
                  _buildTableCell('${(evidence.confidence * 100).toInt()}%'),
                ],
              );
            }),
          ],
        ),
        
        pw.SizedBox(height: 16),
        
        // Evidence Summary
        _buildEvidenceSummary(evidenceList),
      ],
    );
  }

  /// Build a table cell
  pw.Widget _buildTableCell(String text, {bool isHeader = false, int? maxLines}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader
              ? const PdfColor.fromInt(0xFF1D2D44) // Dark Charcoal
              : PdfColors.black,
        ),
        maxLines: maxLines,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  /// Build evidence summary statistics
  pw.Widget _buildEvidenceSummary(List<Evidence> evidenceList) {
    final weaponCount = evidenceList.where((e) => e.type.toLowerCase().contains('weapon')).length;
    final biologicalCount = evidenceList.where((e) => e.type.toLowerCase().contains('biological')).length;
    final documentCount = evidenceList.where((e) => e.type.toLowerCase().contains('document')).length;
    final fingerprintCount = evidenceList.where((e) => e.type.toLowerCase().contains('fingerprint')).length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFFAF9F7), // Warm Off-White tint
        border: pw.Border.fromBorderSide(
          pw.BorderSide(
            color: PdfColor.fromInt(0xFFB4C6A6), // Light Sage
            width: 1,
          ),
        ),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Evidence Summary',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF1D2D44), // Dark Charcoal
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Total Evidence Items: ${evidenceList.length}', style: const pw.TextStyle(fontSize: 11)),
          pw.Text('Weapons: $weaponCount', style: const pw.TextStyle(fontSize: 11)),
          pw.Text('Biological Materials: $biologicalCount', style: const pw.TextStyle(fontSize: 11)),
          pw.Text('Documents: $documentCount', style: const pw.TextStyle(fontSize: 11)),
          pw.Text('Fingerprints: $fingerprintCount', style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  /// Build the footer
  pw.Widget _buildFooter(Report report, pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColor.fromInt(0xFFB4C6A6), // Light Sage
            width: 1,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'ClueScraper Forensic Analysis',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  /// Truncate text to specified length
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Save PDF to device storage
  Future<File> _savePdf(pw.Document pdf, String reportId) async {
    try {
      final output = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${output.path}/reports');
      
      // Create directory if it doesn't exist
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }
      
      final file = File('${reportsDir.path}/report_$reportId.pdf');
      
      // Save PDF bytes
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      
      return file;
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }
}
