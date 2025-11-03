import 'package:flutter/material.dart';

/// Staggered list animation for entrance effects
/// Items fade in and slide up with slight delay
class StaggeredListView extends StatefulWidget {
  final List<Widget> children;
  final Duration totalDuration;
  final Curve curve;
  final int delayBetweenItems; // in milliseconds
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const StaggeredListView({
    super.key,
    required this.children,
    this.totalDuration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOut,
    this.delayBetweenItems = 50,
    this.controller,
    this.padding,
    this.physics,
  });

  @override
  State<StaggeredListView> createState() => _StaggeredListViewState();
}

class _StaggeredListViewState extends State<StaggeredListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      padding: widget.padding,
      physics: widget.physics,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return _StaggeredListItem(
          controller: _controller,
          index: index,
          delay: widget.delayBetweenItems,
          curve: widget.curve,
          child: widget.children[index],
        );
      },
    );
  }
}

class _StaggeredListItem extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final int delay;
  final Curve curve;
  final Widget child;

  const _StaggeredListItem({
    required this.controller,
    required this.index,
    required this.delay,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animationDuration = 300; // Duration of each item's animation in ms
    final delayMs = index * delay;
    final totalDuration = controller.duration!.inMilliseconds;
    
    final animationStart = delayMs / totalDuration;
    final animationEnd = ((delayMs + animationDuration) / totalDuration).clamp(0.0, 1.0);

    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(animationStart, animationEnd, curve: curve),
      ),
    );

    final slideOffset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(animationStart, animationEnd, curve: curve),
      ),
    );

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: slideOffset,
        child: child,
      ),
    );
  }
}
