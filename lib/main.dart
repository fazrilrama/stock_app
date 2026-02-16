import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/services/api_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthService(), permanent: true);
  Get.put(ApiService(), permanent: true);

  final authService = AuthService();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          authService.isLoggedIn ? Routes.Main : Routes.LOGIN,
      getPages: AppPages.pages,
    ),
  );
}
