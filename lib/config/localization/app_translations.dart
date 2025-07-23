import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:teriak/config/localization/languages/ar_sy.dart';
import 'package:teriak/config/localization/languages/en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS, 
    'ar_SY': arSY,
  };
}
