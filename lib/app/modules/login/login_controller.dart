import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/api_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final api = ApiService();
  final box = GetStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final res = await api.login(email, password);
      
      final fullname = res.data['data']['fullname'];
      final username = res.data['data']['username'];
      final token = res.data['token'];

      box.write('token', token);
      box.write('fullname', fullname);
      box.write('username', username);

      Get.offAllNamed(Routes.Main);
    } catch (e) {
      Get.snackbar('Login gagal', 'Email / password salah');
    } finally {
      isLoading.value = false;
    }
  }
}
