import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/core/theme/app_colors.dart';
import 'package:prueba/core/theme/app_text_styles.dart';
import 'package:prueba/features/auth/presentation/controllers/login_controller.dart';
import 'package:prueba/features/auth/presentation/pages/login_page.dart';
import 'package:prueba/features/tasks/domain/entities/task.dart';
import 'package:prueba/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:prueba/features/tasks/presentation/pages/task_form_page.dart';
import 'package:prueba/features/tasks/presentation/widgets/task_card.dart';

class TasksPage extends GetView<TasksController> {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: const Text('To Do List', style: AppTextStyles.appBarBrandTitle),
        actions: [
          IconButton(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const TaskFormPage()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva tarea'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value case final error?) {
            return _MessageState(
              icon: Icons.error_outline,
              title: 'Ocurrió un problema',
              message: error,
              actionLabel: 'Reintentar',
              onAction: controller.retryLoading,
            );
          }

          final visibleTasks = controller.visibleTasks;
          return Column(
            children: [
              _TaskFilters(
                selected: controller.selectedFilter.value,
                onSelected: controller.changeFilter,
              ),
              Expanded(
                child: visibleTasks.isEmpty
                    ? _EmptyTasks(filter: controller.selectedFilter.value)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 2, 16, 96),
                        itemCount: visibleTasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = visibleTasks[index];
                          return TaskCard(
                            task: task,
                            onToggle: () => controller.toggleCompleted(task),
                            onEdit: () =>
                                Get.to(() => TaskFormPage(task: task)),
                            onDelete: () => _confirmDelete(context, task),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Deseas eliminar “${task.title}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.deleteTask(task);
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout_rounded),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    Get.find<LoginController>().clearForm();
    Get.offAll(() => const LoginPage());
  }
}

class _TaskFilters extends StatelessWidget {
  const _TaskFilters({required this.selected, required this.onSelected});
  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
    child: Row(
      children: TaskFilter.values.map((filter) {
        final active = selected == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            selected: active,
            onSelected: (_) => onSelected(filter),
            avatar: Icon(_icon(filter), size: 18),
            label: Text(_label(filter)),
            showCheckmark: false,
            selectedColor: AppColors.navy,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: active ? AppColors.navy : AppColors.lightAqua,
            ),
            labelStyle: TextStyle(
              color: active ? Colors.white : AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(
              color: active ? Colors.white : AppColors.blue,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        );
      }).toList(),
    ),
  );

  String _label(TaskFilter value) => switch (value) {
    TaskFilter.all => 'Todas',
    TaskFilter.pending => 'Pendientes',
    TaskFilter.completed => 'Completadas',
  };

  IconData _icon(TaskFilter value) => switch (value) {
    TaskFilter.all => Icons.view_list_rounded,
    TaskFilter.pending => Icons.schedule_rounded,
    TaskFilter.completed => Icons.check_circle_outline_rounded,
  };
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.filter});
  final TaskFilter filter;

  @override
  Widget build(BuildContext context) => _MessageState(
    icon: Icons.task_alt_rounded,
    title: 'Sin tareas',
    message: switch (filter) {
      TaskFilter.all => 'Crea tu primera tarea para comenzar.',
      TaskFilter.pending => 'No tienes tareas pendientes.',
      TaskFilter.completed => 'Todavía no hay tareas completadas.',
    },
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: AppColors.lightAqua,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 42, color: AppColors.navy),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    ),
  );
}
