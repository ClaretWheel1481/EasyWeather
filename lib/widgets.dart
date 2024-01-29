import 'package:easyweather/function.dart';
import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/items.dart';
import 'package:easyweather/home.dart';

// Container阴影
BoxShadow boxShadows(){
  return const BoxShadow(
    color: Color.fromARGB(78, 0, 0, 0),
    blurRadius: 2,
    offset: Offset(0, 4)
  );
}

// 根据状态改变部分组件的颜色
Color themeColor(){
  if(Get.isDarkMode){
    return const Color.fromARGB(255, 45, 49, 65);
  }
  return const Color.fromARGB(255, 253, 252, 255);
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
