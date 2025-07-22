import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class RainAnimation extends StatefulWidget {
  final int dropCount;
  final double maxHeight;
  const RainAnimation(
      {super.key, this.dropCount = 40, required this.maxHeight});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_RainDrop> _drops;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _drops = List.generate(widget.dropCount, (_) => _RainDrop.random(_random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: Size(MediaQuery.of(context).size.width, widget.maxHeight),
        painter: _RainPainter(_drops, _controller.value, widget.maxHeight),
      ),
    );
  }
}

class _RainDrop {
  final double x;
  final double length;
  final double speed;
  final double thickness;
  final double opacity;
  final double phase;

  _RainDrop({
    required this.x,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.opacity,
    required this.phase,
  });

  factory _RainDrop.random(Random random) {
    final double depth = pow(random.nextDouble(), 1).toDouble();
    final double length = lerpDouble(18, 36, depth)!;
    final double speed = lerpDouble(1.3, 2.2, depth)!;
    final double thickness = lerpDouble(1.2, 2.8, 1 - depth)!;
    final double opacity = lerpDouble(0.25, 0.4, 1 - depth)!;
    return _RainDrop(
      x: random.nextDouble(),
      length: length,
      speed: speed,
      thickness: thickness,
      opacity: opacity,
      phase: random.nextDouble(),
    );
  }
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;
  final double progress;
  final double maxHeight;
  final Random _random = Random();

  _RainPainter(this.drops, this.progress, this.maxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drops.length; i++) {
      var drop = drops[i];
      final double t = (progress + drop.phase) % 1.0;
      final double y = t * size.height * drop.speed;
      final double dx = drop.x * size.width;

      // 重新生成参数
      if (y > size.height) {
        drops[i] = _RainDrop.random(_random);
        continue;
      }

      final Paint paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = drop.thickness
        ..color = Colors.white.withValues(alpha: drop.opacity);
      canvas.drawLine(
        Offset(dx, y),
        Offset(dx, y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
