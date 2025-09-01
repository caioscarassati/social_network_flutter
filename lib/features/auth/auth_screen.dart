import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/app/ui/utils/responsive.dart';
import 'package:social_network/features/auth/auth_controller.dart';
import 'package:social_network/app/routes/app_pages.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Ouve a mudança de estado para navegar
    controller.navigateToUsers.listen((shouldNavigate) {
      if (shouldNavigate) {
        Get.offAllNamed(Routes.dashborard);
      }
    });

    // Ouve a mudança de estado para mostrar a snackbar de erro
    controller.errorMessage.listen((message) {
      if (message.isNotEmpty) {
        Get.snackbar(
          'error_login_failed'.tr,
          message.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: _buildForm(context),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _buildForm(context),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(
                  () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'login_title'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'email_hint'.tr,
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: controller.emailError.value.isEmpty
                          ? null
                          : controller.emailError.value.tr,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'password_hint'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      errorText: controller.passwordError.value.isEmpty
                          ? null
                          : controller.passwordError.value.tr,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: controller.login,
                    child: Text('login_button'.tr),
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

