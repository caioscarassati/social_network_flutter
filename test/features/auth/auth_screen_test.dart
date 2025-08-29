import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:social_network/core/lang/app_translations.dart';
import 'package:social_network/features/auth/auth_controller.dart';
import 'package:social_network/features/auth/auth_screen.dart';

import 'auth_controller_test.mocks.dart';

void main() {
  // Garante que o Flutter está inicializado para os testes
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true; // Ativa o modo de teste do GetX
    Get.addTranslations(AppTranslations().keys); // Adiciona as traduções
  });

  // Função helper para construir o widget de teste
  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      theme: ThemeData(), // Usa um tema padrão para os testes para evitar erros de compilação.
      home: child,
      translations: AppTranslations(),
      locale: const Locale('pt', 'BR'),
    );
  }

  group('AuthScreen Widget Tests', () {
    late AuthController controller;
    late MockLocalUserProvider mockProvider;

    setUp(() {
      // Cria as instâncias antes de cada teste
      mockProvider = MockLocalUserProvider();
      controller = AuthController(mockProvider);
      // Injeta o controller para que a AuthScreen o possa encontrar
      Get.put(controller);
    });

    tearDown(() {
      // Limpa as instâncias do GetX após cada teste para evitar interferências
      Get.reset();
    });



    testWidgets('Deve mostrar erro de validação para e-mail inválido',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(buildTestableWidget(const AuthScreen()));

          // Act
          // Simula a digitação de um e-mail inválido e o toque no botão
          await tester.enterText(
              find.byType(TextField).first, 'invalid-email');
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump(); // Espera a UI reconstruir

          // Assert
          // Verifica se a mensagem de erro de validação aparece
          expect(find.text('error_invalid_email'.tr), findsOneWidget);
        });

    testWidgets('Deve mostrar erro de validação para senha curta',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(buildTestableWidget(const AuthScreen()));

          // Act
          // Simula a digitação de um e-mail válido mas uma senha curta
          await tester.enterText(
              find.byType(TextField).first, 'test@email.com');
          await tester.enterText(find.byType(TextField).last, '123');
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

          // Assert
          expect(find.text('error_password_length'.tr), findsOneWidget);
        });
  });
}

