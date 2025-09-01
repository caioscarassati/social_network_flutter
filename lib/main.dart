import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_network/app/data/models/post_cache_model.dart';
import 'package:social_network/app/data/models/user_cache_model.dart';
import 'package:social_network/app/data/models/user_model.dart';
import 'package:social_network/app/data/provider/local_user_provider.dart';
import 'package:social_network/app/routes/app_pages.dart';
import 'package:social_network/app/ui/theme/app_theme.dart';
import 'package:social_network/core/lang/app_translations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //  Inicializa a formatação de data ---
  await initializeDateFormatting();

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  // Registar os TypeAdapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserCacheModelAdapter());
  Hive.registerAdapter(PostCacheModelAdapter());

  await _seedInitialUser();

  runApp(const MyApp());
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

Future<void> _seedInitialUser() async {
  final localUserProvider = LocalUserProvider();
  final isBoxEmpty = await localUserProvider.isUserBoxEmpty();

  if (isBoxEmpty) {
    final adminUser = User(
      id: const Uuid().v4(),
      email: 'admin@email.com',
      password: 'admin123',
      name: 'Admin User',
    );
    await localUserProvider.addUser(adminUser);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social Network',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
