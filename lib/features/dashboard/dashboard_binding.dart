import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/app/data/provider/local_post_cache_provider.dart';
import 'package:social_network/app/data/provider/local_user_cache_provider.dart';
import 'package:social_network/app/data/provider/post_provider.dart';
import 'package:social_network/app/data/provider/user_provider.dart';
import 'package:social_network/app/data/repository/post_repository.dart';
import 'package:social_network/app/data/repository/user_repository.dart';
import 'package:social_network/features/dashboard/dashboard_controller.dart';
import 'package:social_network/features/posts/posts_controller.dart';
import 'package:social_network/features/users/users_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Controller principal do Dashboard
    Get.lazyPut(() => DashboardController());

    // --- Dependências da Feature de Usuários ---
    Get.lazyPut(() => UserProvider(httpClient: http.Client()));
    Get.lazyPut(() => LocalUserCacheProvider());
    Get.lazyPut(() => UserRepository(
        userProvider: Get.find(), localUserCacheProvider: Get.find()));
    Get.lazyPut(() => UsersController(userRepository: Get.find()));

    // --- Dependências da Feature de Posts ---
    Get.lazyPut(() => PostProvider());
    Get.lazyPut(() => LocalPostCacheProvider());
    Get.lazyPut(() => PostRepository(
        postProvider: Get.find(), localPostCacheProvider: Get.find()));
    Get.lazyPut(() => PostsController(postRepository: Get.find()));
  }
}
