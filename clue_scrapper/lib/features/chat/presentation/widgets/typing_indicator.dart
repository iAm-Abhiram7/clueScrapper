import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated typing indicator shown when AI is processing
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 50, bottom: 8),
      child: Row(
        children: [
          // AI Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: appColors.indigoInk.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology, size: 18, color: appColors.indigoInk),
          ),
          const SizedBox(width: 8),
          // Typing animation
          Container(
            decoration: BoxDecoration(
              color: appColors.surface,
              border: Border.all(color: appColors.lightSage, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0, appColors),
                const SizedBox(width: 4),
                _buildDot(1, appColors),
                const SizedBox(width: 4),
                _buildDot(2, appColors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, AppColors appColors) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.2;
        final progress = (_controller.value - delay) % 1.0;
        final scale = progress < 0.5
            ? 1.0 + (progress * 0.4)
            : 1.4 - ((progress - 0.5) * 0.8);

        return Transform.scale(
          scale: scale.clamp(1.0, 1.4),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: appColors.indigoInk,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
