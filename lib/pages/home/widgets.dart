import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/utils/items.dart';

// 未来时间代码
Widget buildRowDate(RxString date, String weekday) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text.rich(
        TextSpan(
          children: <InlineSpan>[
            const WidgetSpan(
              child: SizedBox(
                width: 16,
                height: 22,
                child: Icon(Icons.date_range_rounded),
              ),
            ),
            TextSpan(
              text: "  $date   ${weeks[weekday]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  );
}

// 未来天气代码
Widget buildRowWeather(RxString lt, RxString ht, String weather) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text.rich(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(text: " ", style: TextStyle(fontSize: 16)),
            WidgetSpan(
              child: SizedBox(
                width: 16,
                height: 28,
                child: Icon(weatherIcons[weather]),
              ),
            ),
            WidgetSpan(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 40, minWidth: 90),
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    '   $weather',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            WidgetSpan(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 80),
                child: Text(
                  '$lt° ~ $ht°',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
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
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: SizedBox(
                    width: 16,
                    height: 23,
                    child: Icon(indiceIcon),
                  ),
                ),
                TextSpan(
                  text: '   $indiceTitle',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Center(
        child: Text(
          indice,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ],
  );
}
