import 'package:prueba/features/tasks/domain/entities/task.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchTasks();

  Future<void> save(Task task);

  Future<void> delete(int id);
}
