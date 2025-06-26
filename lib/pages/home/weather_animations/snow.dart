import 'package:flutter/material.dart';
import 'dart:math';

// 雪花动画组件
class SnowAnimation extends StatefulWidget {
  final int snowCount;
  final double maxHeight;
  const SnowAnimation(
      {super.key, this.snowCount = 35, required this.maxHeight});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SnowFlake> _flakes;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() {
        setState(() {});
      })
      ..repeat();
    _flakes = List.generate(widget.snowCount, (index) => _randomFlake());
  }

  _SnowFlake _randomFlake() {
    return _SnowFlake(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      radius: 2.5 + _random.nextDouble() * 2.5, // 雪花半径2.5~5
      speed: 0.2 + _random.nextDouble() * 0.7, // 下落速度
      drift: (_random.nextDouble() - 0.5) * 0.01, // 左右漂移
      opacity: 0.5 + _random.nextDouble() * 0.5,
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
    for (var flake in _flakes) {
      flake.y += flake.speed * 0.01;
      flake.x += flake.drift;
      if (flake.y * maxHeight > maxHeight || flake.x < 0 || flake.x > 1) {
        // 到达底部或漂出边界后重置到顶部
        flake.x = _random.nextDouble();
        flake.y = 0;
        flake.radius = 2.5 + _random.nextDouble() * 2.5;
        flake.speed = 0.2 + _random.nextDouble() * 0.7;
        flake.drift = (_random.nextDouble() - 0.5) * 0.01;
        flake.opacity = 0.5 + _random.nextDouble() * 0.5;
      }
    }
    return CustomPaint(
      size: Size(double.infinity, maxHeight),
      painter: _SnowPainter(_flakes, maxHeight),
    );
  }
}

class _SnowFlake {
  double x; // 0~1, 相对宽度
  double y; // 0~1, 相对高度
  double radius;
  double speed;
  double drift;
  double opacity;
  _SnowFlake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.drift,
    required this.opacity,
  });
}

class _SnowPainter extends CustomPainter {
  final List<_SnowFlake> flakes;
  final double maxHeight;
  _SnowPainter(this.flakes, this.maxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (var flake in flakes) {
      paint.color = Colors.white.withValues(alpha: flake.opacity);
      final double dx = flake.x * size.width;
      final double dy = flake.y * size.height;
      canvas.drawCircle(Offset(dx, dy), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
