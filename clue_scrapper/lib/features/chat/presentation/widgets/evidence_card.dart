import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/evidence.dart';

/// Evidence card displayed within AI messages
class EvidenceCard extends StatelessWidget {
  final Evidence evidence;

  const EvidenceCard({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: appColors.lightSage.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: appColors.indigoInk, width: 4)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon based on evidence type
              Text(
                _getEvidenceIcon(evidence.type),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatType(evidence.type),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.darkCharcoal,
                  ),
                ),
              ),
              // Confidence badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(evidence.confidence, appColors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(evidence.confidence * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            evidence.description,
            style: TextStyle(
              fontSize: 13,
              color: appColors.graphite,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          // Confidence progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: evidence.confidence,
              backgroundColor: appColors.mutedSand.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getConfidenceColor(evidence.confidence, appColors),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  String _getEvidenceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return '🔪';
      case 'biological':
        return '🧬';
      case 'document':
        return '📄';
      case 'fingerprint':
        return '👆';
      default:
        return '🔍';
    }
  }

  String _formatType(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }

  Color _getConfidenceColor(double confidence, AppColors appColors) {
    if (confidence >= 0.8) {
      return appColors.success;
    } else if (confidence >= 0.5) {
      return appColors.warning;
    } else {
      return appColors.error;
    }
  }
}
