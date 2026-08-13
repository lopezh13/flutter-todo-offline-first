import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/app.dart';
import 'package:prueba/features/auth/data/local_auth_service.dart';
import 'package:prueba/features/auth/presentation/controllers/login_controller.dart';
import 'package:prueba/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:prueba/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:prueba/features/tasks/domain/repositories/task_repository.dart';
import 'package:prueba/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:prueba/objectbox.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await openStore();

  Get.put<Store>(store, permanent: true);
  Get.put<LocalAuthService>(const LocalAuthService(), permanent: true);
  Get.put<LoginController>(
    LoginController(Get.find<LocalAuthService>()),
    permanent: true,
  );
  Get.put<TaskLocalDataSource>(
    ObjectBoxTaskLocalDataSource(store),
    permanent: true,
  );
  Get.put<TaskRepository>(
    TaskRepositoryImpl(Get.find<TaskLocalDataSource>()),
    permanent: true,
  );
  Get.lazyPut<TasksController>(
    () => TasksController(Get.find<TaskRepository>()),
    fenix: true,
  );

  runApp(const TodoApp());
}
