import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';
import '../../app/routes/app_pages.dart';


class AuthController extends GetxController {
  final LocalUserProvider localUserProvider;
  AuthController({required this.localUserProvider});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();
  final snackbarMessage = RxnString();
  final navigateToUsers = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() => emailError.value = null);
    passwordController.addListener(() => passwordError.value = null);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool _validateFields() {
    bool isValid = true;
    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'error_invalid_email'.tr;
      isValid = false;
    }
    if (passwordController.text.length < 6) {
      passwordError.value = 'error_password_length'.tr;
      isValid = false;
    }
    return isValid;
  }

  Future<void> login() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    final email = emailController.text;
    final password = passwordController.text;

    final user = await localUserProvider.getUserByEmail(email);

    if (user != null && user.password == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'token_for_${user.id}');
      // --- ALTERAÇÃO: Navega para o Dashboard ---
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      snackbarMessage.value = 'error_login_failed'.tr;
    }

    isLoading.value = false;
  }
}
