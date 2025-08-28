import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/app/data/provider/local_user_cache_provider.dart';
import 'package:social_network/app/data/provider/user_provider.dart';
import 'package:social_network/app/data/repository/user_repository.dart';
import 'package:social_network/features/users/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    // Injeta os provedores de dados
    Get.lazyPut<UserProvider>(
          () => UserProvider(httpClient: http.Client()),
    );
    Get.lazyPut<LocalUserCacheProvider>(
          () => LocalUserCacheProvider(),
    );

    // Injeta o repositório que depende dos provedores
    Get.lazyPut<UserRepository>(
          () => UserRepository(
        userProvider: Get.find<UserProvider>(),
        localUserCacheProvider: Get.find<LocalUserCacheProvider>(),
      ),
    );

    // Injeta o controller da feature
    Get.lazyPut<UsersController>(
          () => UsersController(userRepository: Get.find<UserRepository>()),
    );
  }
}
