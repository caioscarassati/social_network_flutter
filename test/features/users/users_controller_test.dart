import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/app/data/models/user_api_model.dart';
import 'package:social_network/app/data/repository/user_repository.dart';
import 'package:social_network/core/lang/app_translations.dart';
import 'package:social_network/features/users/users_controller.dart';

// Gera o mock para o UserRepository
@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'users_controller_test.mocks.dart';

void main() {
  late UsersController usersController;
  late MockUserRepository mockUserRepository;
  late UserApiResponseModel page1Response;

  setUp(() {
    Get.reset();
    mockUserRepository = MockUserRepository();
    usersController = UsersController(userRepository: mockUserRepository);

    // Dados de teste para simular a resposta da API com múltiplos utilizadores
    page1Response = UserApiResponseModel(
      page: 1, totalPages: 1, perPage: 2, total: 2,
      data: [
        UserApiModel(id: 1, email: 'a@a.com', firstName: 'John', lastName: 'Doe', avatar: ''),
        UserApiModel(id: 2, email: 'b@b.com', firstName: 'Jane', lastName: 'Smith', avatar: '')
      ],
    );

    SharedPreferences.setMockInitialValues({});
    Get.addTranslations(AppTranslations().keys);
    Get.testMode = true;
  });

  group('UsersController Unit Tests', () {
    // Este é agora um teste unitário puro e rápido.
    test('fetchUsers deve carregar a primeira página de utilizadores com sucesso', () async {
      // Arrange
      when(mockUserRepository.getUsers(page: 1)).thenAnswer((_) async => page1Response);

      // Act
      await usersController.fetchUsers();

      // Assert
      expect(usersController.status.value, Status.success);
      expect(usersController.users.length, 2);
      expect(usersController.users[0].firstName, 'John');
    });

    test('A pesquisa deve filtrar a lista de utilizadores corretamente', () async {
      // Arrange
      // Para testar o filtro, primeiro populamos a lista.
      when(mockUserRepository.getUsers(page: 1)).thenAnswer((_) async => page1Response);
      await usersController.fetchUsers();
      expect(usersController.users.length, 2);

      // Act: Simula a digitação no campo de pesquisa da forma correta para acionar o listener
      usersController.searchController.value = const TextEditingValue(text: 'Jane');

      // Assert: Verifica se a lista foi filtrada
      expect(usersController.users.length, 1);
      expect(usersController.users[0].firstName, 'Jane');

      // Act 2: Simula a limpeza do campo de pesquisa
      usersController.searchController.clear();

      // Assert 2: Verifica se a lista original foi restaurada
      expect(usersController.users.length, 2);
    });
  });
}
