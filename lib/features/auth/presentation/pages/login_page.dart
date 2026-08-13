import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba/core/theme/app_text_styles.dart';
import 'package:prueba/features/auth/presentation/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'To Do List',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.brandTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bienvenido',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingresa para administrar tus tareas',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: controller.validateUsername,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            tooltip: controller.obscurePassword.value
                                ? 'Mostrar contraseña'
                                : 'Ocultar contraseña',
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: controller.validatePassword,
                        onFieldSubmitted: (_) => controller.login(),
                      ),
                    ),
                    Obx(() {
                      final message = controller.errorMessage.value;
                      if (message == null) {
                        return const SizedBox(height: 24);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    }),
                    Obx(
                      () => FilledButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Iniciar sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
