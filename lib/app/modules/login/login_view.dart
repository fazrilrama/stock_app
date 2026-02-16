import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/url_helper.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  LoginController get controller => Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),

              Text(
                'Selamat Datang 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),
              Text(
                'Silakan login untuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 32),

              /// EMAIL
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              /// PASSWORD
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                    ),
                  )),

              SizedBox(height: 24),

              /// LOGIN BUTTON
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value 
                        ? null 
                        : () => controller.login(
                            controller.emailController.text,
                            controller.passwordController.text,
                          ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Login'),
                  )),

              Spacer(),

              TextButton(
                onPressed: () {
                  openWeb('https://helpdesk.bgrlogistik.id');
                },
                child: Text('Belum punya akun?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
