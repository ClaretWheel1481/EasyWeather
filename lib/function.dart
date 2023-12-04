import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easyweather/home.dart';
import 'package:get/get.dart';


void requestLocationPermission() async {    //启用定位权限并检查
  var status = await Permission.location.request();
  if (status.isGranted) {
    try {     //获取经纬度转换为城市
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      controller.locality.value = place.locality!;
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        Get.snackbar("错误", "您没有启用设备的定位服务。");
      } else {
        requestLocationPermission();
      }
    }
  } else if (status.isDenied) {
    Get.snackbar("错误", "您拒绝了EasyWeather的定位权限！");
  } else if (status.isPermanentlyDenied) {
    Get.snackbar("错误", "您拒绝了EasyWeather的定位权限！");
  }
}
