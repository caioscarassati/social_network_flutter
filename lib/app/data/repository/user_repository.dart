import 'package:social_network/app/data/models/user_api_model.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';
import 'package:social_network/app/data/provider/local_user_cache_provider.dart';
import 'package:social_network/app/data/provider/user_provider.dart';

class UserRepository {
  final UserProvider _userProvider;
  final LocalUserCacheProvider _localUserCacheProvider;

  UserRepository({
    required UserProvider userProvider,
    required LocalUserCacheProvider localUserCacheProvider,
  })  : _userProvider = userProvider,
        _localUserCacheProvider = localUserCacheProvider;

  Future<UserApiResponseModel> getUsers({int page = 1}) async {
    try {
      final apiResponse = await _userProvider.getUsers(page: page);

      final cacheUsers = apiResponse.data.map((apiUser) => _mapApiToCache(apiUser)).toList();

      //  Lógica inteligente de cache ---
      // Se for a primeira página (refresh), substitui o cache.
      // Se for uma página subsequente, adiciona ao cache.
      if (page == 1) {
        await _localUserCacheProvider.saveUsers(cacheUsers);
      } else {
        await _localUserCacheProvider.addUsers(cacheUsers);
      }

      return apiResponse;
    } catch (e) {

      final cachedUsers = await _localUserCacheProvider.getUsers();

      if (cachedUsers.isNotEmpty) {
        return UserApiResponseModel(
          page: 1,
          perPage: cachedUsers.length,
          total: cachedUsers.length,
          totalPages: 1,
          data: cachedUsers.map((cacheUser) => _mapCacheToApi(cacheUser)).toList(),
        );
      } else {
        rethrow;
      }
    }
  }

  UserCacheModel _mapApiToCache(UserApiModel apiUser) {
    return UserCacheModel(
      id: apiUser.id,
      email: apiUser.email,
      firstName: apiUser.firstName,
      lastName: apiUser.lastName,
      avatar: apiUser.avatar,
    );
  }

  UserApiModel _mapCacheToApi(UserCacheModel cacheUser) {
    return UserApiModel(
      id: cacheUser.id,
      email: cacheUser.email,
      firstName: cacheUser.firstName,
      lastName: cacheUser.lastName,
      avatar: cacheUser.avatar,
    );
  }
}
