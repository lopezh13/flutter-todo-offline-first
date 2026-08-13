import 'package:objectbox/objectbox.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';

@Entity()
class TaskModel {
  TaskModel({
    this.id = 0,
    required this.title,
    this.description,
    required this.priorityIndex,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @Id()
  int id;
  String title;
  String? description;
  int priorityIndex;
  bool isCompleted;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priorityIndex: task.priority.index,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: TaskPriority.values[priorityIndex],
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
