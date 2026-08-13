import 'dart:async';

import 'package:get/get.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';
import 'package:prueba/features/tasks/domain/repositories/task_repository.dart';

class TasksController extends GetxController {
  TasksController(this._repository);

  final TaskRepository _repository;
  StreamSubscription<List<Task>>? _subscription;

  final tasks = <Task>[].obs;
  final selectedFilter = TaskFilter.all.obs;
  final isLoading = true.obs;
  final isSaving = false.obs;
  final errorMessage = RxnString();

  List<Task> get visibleTasks {
    return switch (selectedFilter.value) {
      TaskFilter.all => tasks,
      TaskFilter.pending => tasks.where((task) => !task.isCompleted).toList(),
      TaskFilter.completed => tasks.where((task) => task.isCompleted).toList(),
    };
  }

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchTasks().listen(
      (items) {
        tasks.assignAll(items);
        errorMessage.value = null;
        isLoading.value = false;
      },
      onError: (_) {
        errorMessage.value = 'No se pudieron cargar las tareas.';
        isLoading.value = false;
      },
    );
  }

  void changeFilter(TaskFilter filter) {
    selectedFilter.value = filter;
  }

  Future<bool> saveTask({
    Task? existingTask,
    required String title,
    required String description,
    required TaskPriority priority,
  }) async {
    isSaving.value = true;
    final now = DateTime.now();
    final cleanDescription = description.trim();

    final task = Task(
      id: existingTask?.id ?? 0,
      title: title.trim(),
      description: cleanDescription.isEmpty ? null : cleanDescription,
      priority: priority,
      isCompleted: existingTask?.isCompleted ?? false,
      createdAt: existingTask?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await _repository.save(task);
      return true;
    } catch (_) {
      Get.snackbar('No se pudo guardar', 'Inténtalo nuevamente.');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> toggleCompleted(Task task) async {
    try {
      await _repository.save(
        task.copyWith(
          isCompleted: !task.isCompleted,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      Get.snackbar('No se pudo actualizar', 'Inténtalo nuevamente.');
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _repository.delete(task.id);
      Get.snackbar('Tarea eliminada', 'La tarea se eliminó correctamente.');
    } catch (_) {
      Get.snackbar('No se pudo eliminar', 'Inténtalo nuevamente.');
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
