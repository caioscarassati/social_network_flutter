import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_network/app/data/models/user_model.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';
import 'package:social_network/features/auth/auth_controller.dart';

import 'auth_controller_test.mocks.dart'; // Importa o novo mock gerado

// Gera o mock para o LocalUserProvider
@GenerateNiceMocks([MockSpec<LocalUserProvider>()])
void main() {
  // Inicializa as dependências do GetX para as traduções
  setUpAll(() => Get.testMode = true);

  group('AuthController Unit Tests', () {
    late AuthController controller;
    late MockLocalUserProvider mockProvider;

    setUp(() {
      // Cria uma nova instância do mock e do controller antes de cada teste
      mockProvider = MockLocalUserProvider();
      controller = AuthController(mockProvider);
    });

    test('Login com credenciais corretas deve navegar para a próxima tela',
            () async {
          // Arrange (Configuração)
          final fakeUser =
          User(id: '1', email: 'admin@email.com', password: 'password123', name: 'Admin User');
          controller.emailController.text = 'admin@email.com';
          controller.passwordController.text = 'password123';

          // Configura o mock para devolver o utilizador falso quando chamado
          when(mockProvider.getUserByEmail('admin@email.com'))
              .thenAnswer((_) async => fakeUser);

          // Act (Ação)
          await controller.login();

          // Assert (Verificação)
          expect(controller.navigateToUsers.value, isTrue);
          expect(controller.errorMessage.value, isEmpty);
        });

    test('Login com senha incorreta deve mostrar mensagem de erro', () async {
      // Arrange
      final fakeUser =
      User(id: '1', email: 'admin@email.com', password: 'password123', name: 'Admin User');
      controller.emailController.text = 'admin@email.com';
      controller.passwordController.text = 'wrongpassword';

      when(mockProvider.getUserByEmail('admin@email.com'))
          .thenAnswer((_) async => fakeUser);

      // Act
      await controller.login();

      // Assert
      expect(controller.navigateToUsers.value, isFalse);
      expect(controller.errorMessage.value, isNotEmpty);
    });

    test('Validação de e-mail inválido deve mostrar erro', () async {
      // Arrange
      controller.emailController.text = 'invalid-email';

      // Act
      await controller.login();

      // Assert
      expect(controller.emailError.value, isNotEmpty);
    });

    test('Validação de senha curta deve mostrar erro', () async {
      // Arrange
      controller.emailController.text = 'admin@email.com';
      controller.passwordController.text = '123';

      // Act
      await controller.login();

      // Assert
      expect(controller.passwordError.value, isNotEmpty);
    });
  });
}

