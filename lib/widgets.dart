import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/items.dart';

// Container阴影
BoxShadow boxShadows(){
  return const BoxShadow(
    color: Color.fromARGB(206, 24, 24, 24),
    blurRadius: 10,
    spreadRadius: 1,
    offset: Offset(1, 2)
  );
}

// 根据状态改变部分组件的颜色
Color themeColor(){
  if(Get.isDarkMode){
    return const Color.fromARGB(255, 56, 56, 56);
  }
  return const Color.fromARGB(255, 255, 255, 255);
}

//未来时间复用代码
Widget buildRowDate(RxString date,String weekday){
  return Row(
          children: <Widget>[
            Text.rich(TextSpan(children: <InlineSpan>[
              const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
              const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
              TextSpan(text:"  $date  ${weeks[weekday]}",style: const TextStyle(fontSize: 18)),
            ])),
          ],
  );
}

//未来天气复用代码
Widget buildRowWeather(RxString lt,RxString ht,String weather){
  return Row(
          children: <Widget>[
            Text.rich(TextSpan(children: <InlineSpan>[
              const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
              WidgetSpan(child: SizedBox(width: 16,height: 26,child: Icon(weatherIcons[weather]))),
              WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 95),child:Container(padding: const EdgeInsets.only(right:40),child: Text('   $weather',style: const TextStyle(fontSize: 18))))),
              TextSpan(text: '     $lt° ~ $ht°',style: const TextStyle(fontSize: 22)),
            ])),
          ],
  );
}

//空白填充
Widget paddingContainer(double insets){
  return Container(
    padding: EdgeInsets.only(top:insets),
  );
}