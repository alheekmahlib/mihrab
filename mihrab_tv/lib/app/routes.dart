import 'package:get/get.dart';

import '../presentation/screens/display/display_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/settings/tv_settings_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const display = '/display';
  static const settings = '/settings';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: display, page: () => const DisplayScreen()),
    GetPage(name: settings, page: () => const TvSettingsScreen()),
  ];
}
