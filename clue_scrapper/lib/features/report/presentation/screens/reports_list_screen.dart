import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/report_provider.dart';
import '../../domain/entities/report.dart';
import 'report_detail_screen.dart';

/// Reports list screen showing all generated reports
class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final reportProvider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by crime type or case ID...',
                prefixIcon: Icon(Icons.search, color: appColors.graphite),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Reports List
          Expanded(
            child: reportProvider.isGenerating
                ? const LoadingIndicator(message: 'Loading reports...')
                : _buildReportsList(reportProvider.reports, appColors),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(List<Report> reports, AppColors appColors) {
    final filteredReports = _filterReports(reports);

    if (filteredReports.isEmpty) {
      return _buildEmptyState(appColors);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ReportProvider>().loadReports();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final report = filteredReports[index];
          return _ReportCard(
            report: report,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailScreen(reportId: report.reportId),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Report> _filterReports(List<Report> reports) {
    if (_searchQuery.isEmpty) return reports;

    return reports.where((report) {
      final crimeType = report.crimeType.toLowerCase();
      final caseId = report.chatId.toLowerCase();
      return crimeType.contains(_searchQuery) || caseId.contains(_searchQuery);
    }).toList();
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Today'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('This Week'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('Sort by Date'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement sort
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors appColors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: appColors.mutedSand,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reports Generated',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: appColors.darkCharcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a report from any chat conversation',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.graphite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Report card widget for displaying individual reports
class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  const _ReportCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final caseId = report.chatId.length > 8 
        ? 'Case #${report.chatId.substring(0, 8).toUpperCase()}'
        : 'Case #${report.chatId.toUpperCase()}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        onLongPress: () {
          _showReportOptions(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: appColors.indigoInk, width: 4),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report Title
                Text(
                  report.crimeType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.darkCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Generated Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: appColors.graphite.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Generated: ${DateFormatter.formatDate(report.generatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: appColors.graphite.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: appColors.mutedSand, height: 1),
                const SizedBox(height: 12),

                // Details Row
                Row(
                  children: [
                    Text(
                      caseId,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: appColors.graphite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.circle,
                      size: 4,
                      color: appColors.graphite.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.article, size: 16, color: appColors.graphite),
                    const SizedBox(width: 4),
                    Text(
                      'Evidence items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: appColors.graphite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export PDF'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement PDF export
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
