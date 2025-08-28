import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:social_network/features/auth/auth_controller.dart';
import 'package:social_network/features/auth/auth_screen.dart';
import 'package:social_network/core/lang/app_translations.dart';

// Importa o mock apenas para o LocalUserProvider
import 'auth_controller_test.mocks.dart';

void main() {
  // tearDown limpa o GetX após cada teste para evitar vazamentos de estado
  tearDown(() {
    Get.reset();
  });

  // Widget wrapper simplificado
  Widget buildTestableWidget() {
    return GetMaterialApp(
      home: const AuthScreen(),
      translations: AppTranslations(),
      locale: const Locale('pt', 'BR'), // Força o locale para prever o texto do erro
    );
  }

  group('AuthScreen Validation Widget Tests', () {
    testWidgets('Deve mostrar erro ao tentar login com e-mail inválido', (tester) async {
      // Arrange
      final mockProvider = MockLocalUserProvider();
      Get.put(AuthController(localUserProvider: mockProvider));
      await tester.pumpWidget(buildTestableWidget());

      // Act
      // Insere um e-mail com formato inválido
      await tester.enterText(find.widgetWithText(TextField, 'E-mail'), 'email-invalido');
      await tester.enterText(find.widgetWithText(TextField, 'Senha'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

      // Avança um frame para a UI ser reconstruída com o estado de erro
      await tester.pump();

      // Assert
      // Verifica se a mensagem de erro de e-mail inválido apareceu
      expect(find.text('Por favor, insira um e-mail válido.'), findsOneWidget);
      // Confirma que nenhuma chamada ao provider foi feita, pois a validação falhou
      verifyNever(mockProvider.getUserByEmail(any));
    });

    testWidgets('Deve mostrar erro ao tentar login com senha curta', (tester) async {
      // Arrange
      final mockProvider = MockLocalUserProvider();
      Get.put(AuthController(localUserProvider: mockProvider));
      await tester.pumpWidget(buildTestableWidget());

      // Act
      // Insere uma senha com menos de 6 caracteres
      await tester.enterText(find.widgetWithText(TextField, 'E-mail'), 'teste@email.com');
      await tester.enterText(find.widgetWithText(TextField, 'Senha'), '12345');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

      // Avança um frame
      await tester.pump();

      // Assert
      // Verifica se a mensagem de erro de senha curta apareceu
      expect(find.text('A senha deve ter no mínimo 6 caracteres.'), findsOneWidget);
      // Confirma que nenhuma chamada ao provider foi feita
      verifyNever(mockProvider.getUserByEmail(any));
    });
  });
}
