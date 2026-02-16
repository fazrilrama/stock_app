import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../notification/notification_controller.dart';
import '../profile/profile_controller.dart';
import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}