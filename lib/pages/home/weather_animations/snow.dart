import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class SnowAnimation extends StatefulWidget {
  final double maxHeight;
  const SnowAnimation({super.key, required this.maxHeight});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SnowFlake> _flakes;
  final Random _random = Random();
  int snowCount = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _flakes = List.generate(snowCount, (_) => _SnowFlake.random(_random));
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
        painter: _SnowPainter(_flakes, _controller.value, widget.maxHeight),
      ),
    );
  }
}

class _SnowFlake {
  double x; // 0~1, 相对宽度
  double phase; // 初始相位
  double radius;
  double speed;
  double drift;
  double opacity;

  _SnowFlake({
    required this.x,
    required this.phase,
    required this.radius,
    required this.speed,
    required this.drift,
    required this.opacity,
  });

  factory _SnowFlake.random(Random random) {
    final double depth = pow(random.nextDouble(), 2).toDouble();
    final double radius = lerpDouble(2.5, 5.0, 1 - depth)!;
    final double speed = lerpDouble(0.7, 1.5, depth)!;
    final double drift =
        (random.nextDouble() - 0.5) * lerpDouble(0.01, 0.04, depth)!;
    final double opacity = lerpDouble(0.4, 0.8, 1 - depth)!;
    return _SnowFlake(
      x: random.nextDouble(),
      phase: random.nextDouble(),
      radius: radius,
      speed: speed,
      drift: drift,
      opacity: opacity,
    );
  }
}

class _SnowPainter extends CustomPainter {
  final List<_SnowFlake> flakes;
  final double progress;
  final double maxHeight;
  final Random _random = Random();

  _SnowPainter(this.flakes, this.progress, this.maxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (int i = 0; i < flakes.length; i++) {
      var flake = flakes[i];
      final double t = (progress + flake.phase) % 1.0;
      final double y = t * (size.height + flake.radius * 2);
      final double dx = flake.x * size.width +
          sin(t * 2 * pi) * 20 * flake.drift * size.width;
      // 如果雪花超出底部或漂出边界，重新生成参数
      if (y > size.height + flake.radius || dx < 0 || dx > size.width) {
        flakes[i] = _SnowFlake.random(_random);
        continue;
      }
      paint.color = Colors.white.withValues(alpha: flake.opacity);
      canvas.drawCircle(Offset(dx, y), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
