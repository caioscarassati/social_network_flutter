import 'package:get/get.dart';
import 'package:social_network/features/auth/auth_binding.dart';
import 'package:social_network/features/auth/auth_screen.dart';
import 'package:social_network/features/dashboard/dashboard_binding.dart';
import 'package:social_network/features/dashboard/dashboard_screen.dart';

abstract class Routes {
  Routes._();
  static const AUTH = '/auth';
  static const DASHBOARD = '/dashboard';
}

class AppPages {
  AppPages._();

  // A rota inicial continua a ser a de autenticação
  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
