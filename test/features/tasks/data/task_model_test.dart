import 'package:flutter_test/flutter_test.dart';
import 'package:prueba/features/tasks/data/models/task_model.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';

void main() {
  test('convierte una tarea al modelo local y conserva sus datos', () {
    final createdAt = DateTime(2026, 8, 13, 10, 30);
    final updatedAt = DateTime(2026, 8, 13, 11);
    final task = Task(
      id: 7,
      title: 'Preparar entrega',
      description: 'Revisar el README',
      priority: TaskPriority.high,
      isCompleted: true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final restoredTask = TaskModel.fromEntity(task).toEntity();

    expect(restoredTask.id, task.id);
    expect(restoredTask.title, task.title);
    expect(restoredTask.description, task.description);
    expect(restoredTask.priority, task.priority);
    expect(restoredTask.isCompleted, task.isCompleted);
    expect(restoredTask.createdAt, createdAt);
    expect(restoredTask.updatedAt, updatedAt);
  });
}
