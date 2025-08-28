import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';
import 'package:social_network/app/data/provider/local_user_cache_provider.dart';
import 'package:social_network/app/data/repository/user_repository.dart';
import 'package:social_network/app/routes/app_pages.dart';
import 'package:social_network/features/profile/profile_controller.dart';
import 'package:social_network/features/profile/profile_dialog.dart';

enum Status { loading, success, error }

class UsersController extends GetxController {
  final UserRepository userRepository;
  final LocalUserCacheProvider _cacheProvider = Get.find();
  UsersController({required this.userRepository});

  final isSearchActive = false.obs;
  final searchController = TextEditingController();
  final _unfilteredUsers = <UserCacheModel>[];

  // --- NOVO ESTADO PARA O FILTRO DE FAVORITOS ---
  final isFavoritesFilterActive = false.obs;

  final users = <UserCacheModel>[].obs;
  final status = Status.loading.obs;
  final errorMessage = ''.obs;

  final _currentPage = 1.obs;
  final _hasNextPage = true.obs;
  final isLoadMoreRunning = false.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    scrollController = ScrollController()..addListener(_loadMoreListener);
    searchController.addListener(_filterUsers);
  }

  @override
  void onClose() {
    scrollController.removeListener(_loadMoreListener);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    // Garante que o filtro de favoritos seja desativado ao fazer um refresh
    if (isFavoritesFilterActive.value) {
      isFavoritesFilterActive.value = false;
    }

    status.value = Status.loading;
    _currentPage.value = 1;
    _hasNextPage.value = true;
    isLoadMoreRunning.value = false;
    users.clear();
    _unfilteredUsers.clear();

    try {
      final result = await userRepository.getUsers(page: _currentPage.value);

      // --- CORREÇÃO: Mapeia os modelos da API para modelos de Cache ---
      final mappedUsers = result.data.map((apiUser) => UserCacheModel(
        id: apiUser.id,
        email: apiUser.email,
        firstName: apiUser.firstName,
        lastName: apiUser.lastName,
        avatar: apiUser.avatar,
      )).toList();

      _unfilteredUsers.addAll(mappedUsers);
      users.assignAll(_unfilteredUsers);
      _hasNextPage.value = result.page < result.totalPages;
      status.value = Status.success;
    } catch (e) {
      errorMessage.value = e.toString();
      status.value = Status.error;
    }
  }

  void _loadMoreListener() {
    // Desativa a paginação se o filtro de favoritos estiver ativo
    if (isFavoritesFilterActive.value) return;
    if (scrollController.position.extentAfter < 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!_hasNextPage.value || isLoadMoreRunning.value) return;

    isLoadMoreRunning.value = true;
    await Future.delayed(const Duration(seconds: 2));
    _currentPage.value += 1;

    try {
      final result = await userRepository.getUsers(page: _currentPage.value);

      // --- CORREÇÃO: Mapeia os modelos da API para modelos de Cache ---
      final mappedUsers = result.data.map((apiUser) => UserCacheModel(
        id: apiUser.id,
        email: apiUser.email,
        firstName: apiUser.firstName,
        lastName: apiUser.lastName,
        avatar: apiUser.avatar,
      )).toList();

      _unfilteredUsers.addAll(mappedUsers);
      if (searchController.text.isEmpty) {
        users.addAll(mappedUsers);
      }
      _hasNextPage.value = result.page < result.totalPages;
    } catch (e) {
      print("Erro ao carregar mais usuários: $e");
    } finally {
      isLoadMoreRunning.value = false;
    }
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchController.clear();
    }
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      users.assignAll(_unfilteredUsers);
    } else {
      final filteredList = _unfilteredUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
      users.assignAll(filteredList);
    }
  }

  // --- NOVO MÉTODO: Alterna o filtro de favoritos ---
  void toggleFavoritesFilter() async {
    isFavoritesFilterActive.value = !isFavoritesFilterActive.value;
    status.value = Status.loading;
    await Future.delayed(const Duration(milliseconds: 300)); // Feedback visual

    if (isFavoritesFilterActive.value) {
      // Busca apenas os favoritos do cache
      final favoriteUsers = await _cacheProvider.getFavoriteUsers();
      users.assignAll(favoriteUsers);
    } else {
      // Restaura a lista completa
      users.assignAll(_unfilteredUsers);
    }
    status.value = Status.success;
  }

  void showUserProfile(UserCacheModel user) {
    Get.lazyPut(() => ProfileController(user: user));

    Get.dialog(
      const ProfileDialog(),
    ).whenComplete(() {
      // Atualiza a lista de favoritos se o filtro estiver ativo
      if (isFavoritesFilterActive.value) {
        toggleFavoritesFilter(); // Re-executa o filtro para refletir as mudanças
      }
      Get.delete<ProfileController>();
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Get.offAllNamed(Routes.AUTH);
  }
}
