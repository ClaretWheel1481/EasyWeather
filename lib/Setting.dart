import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget{
  const Setting({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('深色/浅色模式'),
            children: [
              ListTile(
                title: const Text('浅色'),
                leading: const Icon(Icons.light_mode),
                onTap: (){
                  Get.changeThemeMode(ThemeMode.light);
                },
              ),
              ListTile(
                title: const Text('深色'),
                leading: const Icon(Icons.dark_mode),
                onTap: (){
                  Get.changeThemeMode(ThemeMode.dark);
                },
              ),
              ListTile(
                title: const Text('跟随系统设置'),
                leading: const Icon(Icons.brightness_4_rounded),
                onTap: (){
                  Get.changeThemeMode(ThemeMode.system);
                },
              )
            ],
          )
        ],
      )
    );
  }
}