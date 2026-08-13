import 'package:prueba/features/tasks/data/models/task_model.dart';
import 'package:prueba/objectbox.g.dart';

abstract interface class TaskLocalDataSource {
  Stream<List<TaskModel>> watchTasks();

  Future<void> save(TaskModel task);

  Future<void> delete(int id);
}

class ObjectBoxTaskLocalDataSource implements TaskLocalDataSource {
  ObjectBoxTaskLocalDataSource(Store store) : _box = store.box<TaskModel>();

  final Box<TaskModel> _box;

  @override
  Stream<List<TaskModel>> watchTasks() {
    final query = _box.query().order(
      TaskModel_.updatedAt,
      flags: Order.descending,
    );

    return query.watch(triggerImmediately: true).map((query) => query.find());
  }

  @override
  Future<void> save(TaskModel task) async {
    _box.put(task);
  }

  @override
  Future<void> delete(int id) async {
    final removed = _box.remove(id);
    if (!removed) {
      throw StateError('La tarea no existe');
    }
  }
}
