import 'package:flutter/material.dart';

class ThunderFlashAnimation extends StatefulWidget {
  final double opacity;
  final int fadeInMs;
  final int fadeOutMs;
  final int minIntervalMs;
  final int maxIntervalMs;
  const ThunderFlashAnimation({
    super.key,
    this.opacity = 0.7,
    this.fadeInMs = 110,
    this.fadeOutMs = 380,
    this.minIntervalMs = 4000,
    this.maxIntervalMs = 6000,
  });

  @override
  State<ThunderFlashAnimation> createState() => _ThunderFlashAnimationState();
}

class _ThunderFlashAnimationState extends State<ThunderFlashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flashOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.fadeInMs + widget.fadeOutMs),
    );
    _flashOpacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: widget.fadeInMs.toDouble(),
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: widget.fadeOutMs.toDouble(),
      ),
    ]).animate(_controller);
    _scheduleNextFlash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleNextFlash() async {
    final ms = widget.minIntervalMs +
        (widget.maxIntervalMs - widget.minIntervalMs) *
            (UniqueKey().hashCode % 1000) ~/
            1000;
    await Future.delayed(Duration(milliseconds: ms));
    if (!mounted) return;
    await _controller.forward(from: 0);
    if (!mounted) return;
    _scheduleNextFlash();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _flashOpacity,
        builder: (context, child) => Opacity(
          opacity: _flashOpacity.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white.withValues(alpha: widget.opacity),
        ),
      ),
    );
  }
}
