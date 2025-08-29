import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_network/app/ui/utils/responsive.dart';
import 'package:social_network/features/dashboard/dashboard_controller.dart';
import 'package:social_network/features/posts/posts_screen.dart';
import 'package:social_network/features/users/users_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define o PageView uma vez para ser reutilizado em ambos os layouts.
    final pageView = PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      children: const [
        UsersScreen(),
        PostsScreen(),
      ],
    );

    return Obx(
          () => Responsive(
        // --- Layout para Telemóvel ---
        mobile: Scaffold(
          body: pageView,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline),
                activeIcon: const Icon(Icons.people),
                label: 'nav_bar_users'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.article_outlined),
                activeIcon: const Icon(Icons.article),
                label: 'nav_bar_posts'.tr,
              ),
            ],
          ),
        ),
        // --- Layout para Tablet e Desktop ---
        tablet: Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: controller.currentIndex.value,
                onDestinationSelected: controller.changePage,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.people_outline),
                    selectedIcon: const Icon(Icons.people),
                    label: Text('nav_bar_users'.tr),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.article_outlined),
                    selectedIcon: const Icon(Icons.article),
                    label: Text('nav_bar_posts'.tr),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: pageView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
