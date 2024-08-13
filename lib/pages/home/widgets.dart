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

// 指数组件
Widget buildIndices(String indice, String indiceTitle, IconData indiceIcon) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(indiceIcon, size: 22),
          const SizedBox(width: 5),
          Text(
            indiceTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        indice,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
