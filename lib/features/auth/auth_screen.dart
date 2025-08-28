import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/app/routes/app_pages.dart';
import 'package:social_network/features/auth/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Acedemos ao controller injetado pelo Binding
  final AuthController controller = Get.find();

  @override
  void initState() {
    super.initState();
    // "Ouvinte" para a mensagem de snackbar
    ever(controller.snackbarMessage, (String? message) {
      if (message != null) {
        Get.snackbar(
          'error_title'.tr,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Limpa a mensagem para não ser mostrada novamente
        controller.snackbarMessage.value = null;
      }
    });

    // "Ouvinte" para o sinal de navegação
    ever(controller.navigateToUsers, (bool navigate) {
      if (navigate) {
        // --- CORREÇÃO: Navega para a nova tela de Dashboard ---
        Get.offAllNamed(Routes.DASHBOARD);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'login_title'.tr,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: 'email_hint'.tr,
                        prefixIcon: const Icon(Icons.email),
                        errorText: controller.emailError.value,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                        () => TextField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'password_hint'.tr,
                        prefixIcon: const Icon(Icons.lock),
                        errorText: controller.passwordError.value,
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: controller.login,
                      child: Text('login_button'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
