import 'package:hive/hive.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';

class LocalUserCacheProvider {
  static const String _userListBoxName = 'user_list_cache';

  // Salva uma lista de usuários no cache, substituindo os dados existentes.
  Future<void> saveUsers(List<UserCacheModel> newUsers) async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);

    final Map<int, bool> favoriteStatuses = {
      for (var user in box.values)
        if (user.isFavorite == true) user.id: true
    };

    await box.clear();

    for (var user in newUsers) {
      if (favoriteStatuses.containsKey(user.id)) {
        user.isFavorite = true;
      }
      await box.put(user.id, user);
    }
  }

  // Adiciona usuários ao cache sem limpar os existentes.
  Future<void> addUsers(List<UserCacheModel> users) async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);
    for (var user in users) {
      if (!box.containsKey(user.id)) {
        await box.put(user.id, user);
      }
    }
  }

  // Atualiza o estado de favorito de um utilizador
  Future<void> updateFavoriteStatus(int userId, bool isFavorite) async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);
    final user = box.get(userId);
    if (user != null) {
      user.isFavorite = isFavorite;
      await box.put(userId, user);
    }
  }

  // Busca apenas os utilizadores favoritos
  Future<List<UserCacheModel>> getFavoriteUsers() async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);
    //  Usa uma verificação segura para valores nulos ---
    return box.values.where((user) => user.isFavorite == true).toList();
  }

  // Obtém a lista de todos os usuários do cache
  Future<List<UserCacheModel>> getUsers() async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);
    return box.values.toList();
  }

  // Verifica se o cache de usuários está vazio
  Future<bool> isCacheEmpty() async {
    final box = await Hive.openBox<UserCacheModel>(_userListBoxName);
    return box.isEmpty;
  }
}
