import 'package:flutter/material.dart';
import 'dart:math';

// 雨滴动画组件
class RainAnimation extends StatefulWidget {
  final int dropCount;
  final double maxHeight;
  const RainAnimation(
      {super.key, this.dropCount = 30, required this.maxHeight});

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
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      })
      ..repeat();
    _drops = List.generate(widget.dropCount, (index) => _randomDrop());
  }

  _RainDrop _randomDrop() {
    return _RainDrop(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      length: 15 + _random.nextDouble() * 15,
      speed: 0.5 + _random.nextDouble() * 1.2,
      opacity: 0.3 + _random.nextDouble() * 0.5,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = widget.maxHeight;
    for (var drop in _drops) {
      drop.y += drop.speed * 0.02;
      if (drop.y * maxHeight > maxHeight) {
        // 到达底部后重置到顶部
        drop.x = _random.nextDouble();
        drop.y = 0;
        drop.length = 15 + _random.nextDouble() * 15;
        drop.speed = 0.5 + _random.nextDouble() * 1.2;
        drop.opacity = 0.3 + _random.nextDouble() * 0.5;
      }
    }
    return CustomPaint(
      size: Size(double.infinity, maxHeight),
      painter: _RainPainter(_drops, maxHeight),
    );
  }
}

class _RainDrop {
  double x; // 0~1, 相对宽度
  double y; // 0~1, 相对高度
  double length;
  double speed;
  double opacity;
  _RainDrop(
      {required this.x,
      required this.y,
      required this.length,
      required this.speed,
      required this.opacity});
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;
  final double maxHeight;
  _RainPainter(this.drops, this.maxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.2;
    for (var drop in drops) {
      paint.color = Colors.white.withValues(alpha: drop.opacity);
      final double dx = drop.x * size.width;
      final double dy = drop.y * size.height;
      canvas.drawLine(
        Offset(dx, dy),
        Offset(dx, dy + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
