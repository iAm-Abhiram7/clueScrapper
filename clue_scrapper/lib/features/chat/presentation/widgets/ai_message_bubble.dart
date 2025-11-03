import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/evidence.dart';
import 'evidence_card.dart';

/// AI message bubble (left-aligned, white background)
class AIMessageBubble extends StatelessWidget {
  final Message message;
  final List<Evidence> evidence;

  const AIMessageBubble({
    super.key,
    required this.message,
    this.evidence = const [],
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 50, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appColors.indigoInk.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  size: 18,
                  color: appColors.indigoInk,
                ),
              ),
              const SizedBox(width: 8),
              // Message Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: appColors.surface,
                        border: Border.all(
                          color: appColors.lightSage,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: TextStyle(
                              color: appColors.darkCharcoal,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          // Evidence cards
                          if (evidence.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Text(
                              'Evidence Detected:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: appColors.darkCharcoal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...evidence.map(
                              (ev) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: EvidenceCard(evidence: ev),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: appColors.graphite.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
