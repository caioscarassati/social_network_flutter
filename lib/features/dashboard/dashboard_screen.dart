import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/features/dashboard/dashboard_controller.dart';
import 'package:social_network/features/posts/posts_screen.dart';
import 'package:social_network/features/users/users_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            UsersScreen(),
            PostsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.people),
              label: 'nav_bar_users'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.article),
              label: 'nav_bar_posts'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
