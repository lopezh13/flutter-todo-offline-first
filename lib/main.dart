import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/app.dart';
import 'package:prueba/features/auth/data/local_auth_service.dart';
import 'package:prueba/features/auth/presentation/controllers/login_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut<LocalAuthService>(() => const LocalAuthService());
  Get.lazyPut<LoginController>(
    () => LoginController(Get.find<LocalAuthService>()),
  );

  runApp(const TodoApp());
}
