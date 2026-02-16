import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final token = box.read('token');

    print(token);

    if (token == null && route != Routes.LOGIN) {
      return RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
