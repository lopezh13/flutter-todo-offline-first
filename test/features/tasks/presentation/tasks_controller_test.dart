import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';
import 'package:prueba/features/tasks/domain/repositories/task_repository.dart';
import 'package:prueba/features/tasks/presentation/controllers/tasks_controller.dart';

void main() {
  late _FakeTaskRepository repository;
  late TasksController controller;

  setUp(() {
    Get.testMode = true;
    repository = _FakeTaskRepository();
    controller = TasksController(repository)..onInit();
  });

  tearDown(() async {
    controller.onClose();
    await repository.close();
    Get.reset();
  });

  test('filtra las tareas por estado', () async {
    repository.emit([
      _task(id: 1, isCompleted: false),
      _task(id: 2, isCompleted: true),
    ]);
    await pumpEventQueue();

    controller.changeFilter(TaskFilter.pending);
    expect(controller.visibleTasks.map((task) => task.id), [1]);

    controller.changeFilter(TaskFilter.completed);
    expect(controller.visibleTasks.map((task) => task.id), [2]);
  });

  test('limpia los campos antes de guardar una tarea', () async {
    final result = await controller.saveTask(
      title: '  Comprar café  ',
      description: '   ',
      priority: TaskPriority.high,
    );

    expect(result, isTrue);
    expect(repository.savedTask?.title, 'Comprar café');
    expect(repository.savedTask?.description, isNull);
    expect(repository.savedTask?.priority, TaskPriority.high);
    expect(repository.savedTask?.isCompleted, isFalse);
  });
}

Task _task({required int id, required bool isCompleted}) {
  final date = DateTime(2026, 8, 13);
  return Task(
    id: id,
    title: 'Tarea $id',
    priority: TaskPriority.medium,
    isCompleted: isCompleted,
    createdAt: date,
    updatedAt: date,
  );
}

class _FakeTaskRepository implements TaskRepository {
  final _controller = StreamController<List<Task>>.broadcast();
  Task? savedTask;

  void emit(List<Task> tasks) => _controller.add(tasks);

  Future<void> close() => _controller.close();

  @override
  Stream<List<Task>> watchTasks() => _controller.stream;

  @override
  Future<void> save(Task task) async {
    savedTask = task;
  }

  @override
  Future<void> delete(int id) async {}
}
