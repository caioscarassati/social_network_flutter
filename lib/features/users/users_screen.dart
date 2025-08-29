import 'package:cached_network_image/cached_network_image.dart'; // <-- NOVO IMPORT
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';
import 'package:social_network/features/profile/profile_dialog.dart';
import 'package:social_network/features/users/users_controller.dart';

class UsersScreen extends GetView<UsersController> {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => _buildAppBar()),
      ),
      floatingActionButton: Obx(
            () => FloatingActionButton(
          onPressed: controller.toggleFavoritesFilter,
          tooltip: 'Favoritos',
          child: Icon(
            controller.isFavoritesFilterActive.value
                ? Icons.star
                : Icons.star_border,
          ),
        ),
      ),
      body: Obx(
            () {
          switch (controller.status.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('error_generic'.tr, textAlign: TextAlign.center),
                ),
              );
            case Status.success:
              if (controller.users.isEmpty) {
                return Center(child: Text('no_users_found'.tr));
              }
              return RefreshIndicator(
                onRefresh: controller.fetchUsers,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.8, // Reajustado para o novo layout
                        ),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return UserGridItem(user: user);
                        },
                      ),
                    ),
                    if (controller.isLoadMoreRunning.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    if (controller.isSearchActive.value) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.toggleSearch,
        ),
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'search_hint'.tr,
            border: InputBorder.none,
            //  'withOpacity' substituído por 'withAlpha' ---
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => controller.searchController.clear(),
          ),
        ],
      );
    } else {
      return AppBar(
        title: Text('users_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: controller.toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout_button'.tr,
            onPressed: controller.logout,
          ),
        ],
      );
    }
  }
}

class UserGridItem extends StatelessWidget {
  const UserGridItem({
    super.key,
    required this.user,
  });

  final UserCacheModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      child: InkWell(
        onTap: () => controller.showUserProfile(user),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // --- ALTERAÇÃO: Substituído o botão por um texto estilizado ---
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 6), // Margem inferior de 6
                        child: Text(
                          'profile_details_button'.tr,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).primaryColor, // Cor primária
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                //  'withOpacity' substituído por 'withAlpha' ---
                                color: Colors.black.withAlpha(64), // 0.25 de opacidade
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (user.isFavorite == true)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.star, color: Colors.amber, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
