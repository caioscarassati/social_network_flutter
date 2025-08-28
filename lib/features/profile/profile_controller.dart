import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';
import 'package:social_network/app/data/provider/local_user_cache_provider.dart';

class ProfileController extends GetxController {
  final UserCacheModel user;
  final LocalUserCacheProvider _cacheProvider = Get.find();

  late String jobTitle;
  late String department;
  late String biography;

  final isFavorite = false.obs;

  ProfileController({required this.user});

  @override
  void onInit() {
    super.onInit();
    final faker = Faker();
    jobTitle = faker.job.title();
    department = faker.company.name();
    biography = faker.lorem.sentences(3).join(' ');
    // --- CORREÇÃO: Trata o valor nulo, assumindo 'false' como padrão ---
    isFavorite.value = user.isFavorite ?? false;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // Salva o novo estado no cache local
    _cacheProvider.updateFavoriteStatus(user.id, isFavorite.value);

    Get.snackbar(
      // --- ATUALIZADO: Usa as chaves de tradução ---
      isFavorite.value ? 'added_to_favorites'.tr : 'removed_from_favorites'.tr,
      '${user.firstName} ${user.lastName}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
