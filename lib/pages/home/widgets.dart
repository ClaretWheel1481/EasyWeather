import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/constants/items.dart';

// 未来时间代码
Widget buildRowDate(RxString date, String weekday) {
  return Row(
    children: <Widget>[
      const SizedBox(width: 3),
      Text(
        "  $date   ${weeks[weekday]}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

// 未来天气代码
Widget buildRowWeather(RxString lt, RxString ht, RxString weather) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      const SizedBox(width: 10),
      Icon(weatherIcons[weather.value], size: 22),
      Expanded(
        child: Text(
          '   ${weather.value}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      Column(
        children: [
          const SizedBox(height: 4),
          Text(
            '${lt.value}° ~ ${ht.value}°',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      const SizedBox(width: 10),
    ],
  );
}

// 天气详细组件
Widget buildWeatherInfo(String label, value) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(fontSize: 15),
      ),
    ],
  );
}

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  LinePainter({required this.points, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
