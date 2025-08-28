import 'package:get/get.dart';
import 'package:social_network/core/lang/en_US.dart';
import 'package:social_network/core/lang/pt_BR.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'pt_BR': ptBR,
    'en_US': enUS,
  };
}
