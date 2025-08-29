import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/app/data/models/user_model.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';

class AuthController extends GetxController {
  final LocalUserProvider _localUserProvider;
  AuthController(this._localUserProvider);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  // Novas variáveis de estado para a View observar
  final errorMessage = ''.obs;
  final navigateToUsers = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // --- MÉTODOS DE VALIDAÇÃO SEPARADOS ---
  // Estes métodos podem ser chamados a partir da View (ex: num onChanged ou FocusNode listener)

  /// Valida o campo de e-mail. Retorna `true` se for válido.
  bool validateEmail() {
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'error_invalid_email';
      return false;
    }
    emailError.value = '';
    return true;
  }

  /// Valida o campo de senha. Retorna `true` se for válido.
  bool validatePassword() {
    if (passwordController.text.length < 6) {
      passwordError.value = 'error_password_length';
      return false;
    }
    passwordError.value = '';
    return true;
  }

  Future<void> login() async {
    // Limpa o erro de login anterior
    errorMessage.value = '';

    // Executa ambas as validações para garantir que todos os erros sejam mostrados
    // antes de tentar o login.
    final isEmailValid = validateEmail();
    final isPasswordValid = validatePassword();

    // Se qualquer um dos campos for inválido, interrompe a execução.
    if (!isEmailValid || !isPasswordValid) {
      return;
    }

    isLoading.value = true;

    try {
      final User? user =
      await _localUserProvider.getUserByEmail(emailController.text);

      if (user != null && user.password == passwordController.text) {
        // Simula a navegação após o sucesso
        navigateToUsers.value = true;
      } else {
        errorMessage.value = 'error_login_failed';
      }
    } catch (e) {
      errorMessage.value = 'error_generic';
    } finally {
      isLoading.value = false;
    }
  }
}

