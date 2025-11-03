import 'package:flutter/material.dart';

/// Button with subtle press animation
/// Provides tactile feedback with scale effect
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scaleAmount;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 100),
    this.scaleAmount = 0.95,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => _setScale(widget.scaleAmount) : null,
      onTapUp: widget.onPressed != null ? (_) => _setScale(1.0) : null,
      onTapCancel: widget.onPressed != null ? () => _setScale(1.0) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }

  void _setScale(double scale) {
    if (mounted) {
      setState(() => _scale = scale);
    }
  }
}
