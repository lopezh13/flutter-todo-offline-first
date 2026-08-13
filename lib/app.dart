import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/core/theme/app_theme.dart';
import 'package:prueba/features/splash/presentation/pages/splash_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashPage(),
    );
  }
}
