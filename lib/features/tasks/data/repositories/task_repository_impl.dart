import 'package:prueba/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:prueba/features/tasks/data/models/task_model.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';
import 'package:prueba/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._localDataSource);

  final TaskLocalDataSource _localDataSource;

  @override
  Stream<List<Task>> watchTasks() {
    return _localDataSource.watchTasks().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> save(Task task) {
    return _localDataSource.save(TaskModel.fromEntity(task));
  }

  @override
  Future<void> delete(int id) {
    return _localDataSource.delete(id);
  }
}
