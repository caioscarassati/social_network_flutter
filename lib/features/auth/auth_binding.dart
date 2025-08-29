import 'package:get/get.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';
import 'package:social_network/features/auth/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Injeta o LocalUserProvider para que ele esteja disponível
    Get.lazyPut<LocalUserProvider>(() => LocalUserProvider());

    // Injeta o AuthController, passando a instância do LocalUserProvider
    // que acabamos de registar.
    Get.lazyPut<AuthController>(
          () => AuthController(Get.find<LocalUserProvider>()),
    );
  }
}
