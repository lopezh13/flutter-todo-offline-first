import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Do List')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Todavía no hay tareas.', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
