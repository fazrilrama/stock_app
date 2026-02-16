import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';


class AuthService {
  final box = GetStorage();

  bool get isLoggedIn => box.read('token') != null;

  String? get token => box.read('token');

  void saveToken(String token) {
    box.write('token', token);
  }

  void logout() {
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}