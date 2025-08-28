import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/app/data/models/user_model.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';
import 'package:social_network/features/auth/auth_controller.dart';
import 'package:social_network/core/lang/app_translations.dart';

// --- ALTERAÇÃO: Usar @GenerateNiceMocks para evitar erros de stub ---
@GenerateNiceMocks([MockSpec<LocalUserProvider>(), MockSpec<AuthController>()])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController authController;
  late MockLocalUserProvider mockLocalUserProvider;
  late User testUser;

  // Configuração inicial antes de cada teste
  setUp(() {
    // Limpa as instâncias do Get para garantir um teste limpo
    Get.reset();

    mockLocalUserProvider = MockLocalUserProvider();
    authController = AuthController(localUserProvider: mockLocalUserProvider);
    testUser = User(
      id: '1',
      email: 'test@email.com',
      password: 'password123',
      name: 'Test User',
    );

    // Simula o SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Adiciona as traduções para que '.tr' funcione nos testes
    Get.testMode = true;
    Get.addTranslations(AppTranslations().keys);
  });

  group('AuthController Logic Tests', () {
    test('Login com sucesso deve atualizar o estado navigateToUsers para true', () async {
      // Arrange
      when(mockLocalUserProvider.getUserByEmail(any))
          .thenAnswer((_) async => testUser);
      authController.emailController.text = 'test@email.com';
      authController.passwordController.text = 'password123';

      // Act
      await authController.login();

      // Assert
      verify(mockLocalUserProvider.getUserByEmail('test@email.com')).called(1);
      expect(authController.navigateToUsers.value, true);
      expect(authController.snackbarMessage.value, isNull);
    });

    test('Login com credenciais incorretas deve atualizar snackbarMessage', () async {
      // Arrange
      when(mockLocalUserProvider.getUserByEmail(any)).thenAnswer((_) async => null);
      authController.emailController.text = 'wrong@email.com';
      authController.passwordController.text = 'password123';

      // Act
      await authController.login();

      // Assert
      expect(authController.snackbarMessage.value, isNotNull);
      expect(authController.navigateToUsers.value, false);
    });

    test('Login com e-mail inválido deve atualizar emailError', () async {
      // Arrange
      authController.emailController.text = 'invalid-email';
      authController.passwordController.text = 'password123';

      // Act
      await authController.login();

      // Assert
      verifyNever(mockLocalUserProvider.getUserByEmail(any));
      expect(authController.emailError.value, isNotNull);
    });

    test('Login com senha curta deve atualizar passwordError', () async {
      // Arrange
      authController.emailController.text = 'test@email.com';
      authController.passwordController.text = '123';

      // Act
      await authController.login();

      // Assert
      verifyNever(mockLocalUserProvider.getUserByEmail(any));
      expect(authController.passwordError.value, isNotNull);
    });
  });
}
