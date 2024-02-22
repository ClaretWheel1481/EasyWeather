import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/items.dart';

// Container阴影
BoxShadow boxShadows(){
  return const BoxShadow(
    color: Color.fromARGB(61, 0, 0, 0),
    blurRadius: 5,
    offset: Offset(0, 3)
  );
}

// 根据状态改变部分组件的颜色
Color themeColor(){
  if(Get.isDarkMode){
    return const Color.fromARGB(255, 53, 57, 65);
  }
  return const Color.fromARGB(255, 220, 220, 221);
}

//未来时间复用代码
Widget buildRowDate(RxString date,String weekday){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text.rich(TextSpan(children: <InlineSpan>[
              const WidgetSpan(child: SizedBox(width: 16,height: 22,child: Icon(Icons.date_range_rounded))),
              TextSpan(text:"  $date   ${weeks[weekday]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            ])),
          ],
  );
}

//未来天气复用代码
Widget buildRowWeather(RxString lt,RxString ht,String weather){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text.rich(TextSpan(children: <InlineSpan>[
              const TextSpan(text:" ",style: TextStyle(fontSize: 16)),
              WidgetSpan(child: SizedBox(width: 16,height: 28,child: Icon(weatherIcons[weather]))),
              WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(maxHeight: 40,minWidth: 90),child:Container(padding: const EdgeInsets.only(right:10),child: Text('   $weather',style: const TextStyle(fontSize: 18))))),
              WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 80),child: Text('$lt° ~ $ht°',style: const TextStyle(fontSize: 18)))),
            ])),
          ],
  );
}

Widget buildIndices(String Indice,String IndiceTitle,IconData IndiceIcon){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(TextSpan(children: <InlineSpan>[
            WidgetSpan(child: SizedBox(width: 16,height: 23,child: Icon(IndiceIcon))),
            TextSpan(text:'   $IndiceTitle',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          ])),
        ],
      ),
      const SizedBox(height: 5),
      Center(
        child: Text(Indice,style: const TextStyle(fontSize: 18)),
      ),
    ],
  );
}