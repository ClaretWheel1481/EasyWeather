import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Container阴影
BoxShadow boxShadows(){
  return const BoxShadow(
    color: Color.fromARGB(52, 0, 0, 0),
    blurRadius: 4,
    spreadRadius: 1,
    offset: Offset(1, 2)
  );
}

// 根据状态改变部分组件的颜色
Color themeColor(){
  if(Get.isDarkMode){
    return const Color.fromARGB(183, 56, 56, 56);
  }
  return const Color.fromARGB(242, 255, 255, 255);
}
