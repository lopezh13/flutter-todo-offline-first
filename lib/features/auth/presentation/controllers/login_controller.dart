import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/features/auth/data/local_auth_service.dart';
import 'package:prueba/features/tasks/presentation/pages/tasks_page.dart';

class LoginController extends GetxController {
  LoginController(this._authService);

  final LocalAuthService _authService;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final errorMessage = RxnString();

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa el usuario';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa la contraseña';
    }
    return null;
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  Future<void> login() async {
    errorMessage.value = null;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;

    try {
      final isAuthenticated = _authService.authenticate(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (!isAuthenticated) {
        errorMessage.value = 'Usuario o contraseña incorrectos';
        return;
      }

      Get.off(() => const TasksPage());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
