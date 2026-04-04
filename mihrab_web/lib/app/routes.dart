import 'package:get/get.dart';

import '../presentation/screens/landing/landing_screen.dart';

class AppRoutes {
  static const landing = '/';
  static const dashboard = '/dashboard';
  static const scanner = '/scanner';
  static const deviceSettings = '/device-settings';

  static final pages = [
    GetPage(name: landing, page: () => const LandingScreen()),
  ];
}
