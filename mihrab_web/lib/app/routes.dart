import 'package:get/get.dart';

import '../presentation/screens/landing/landing_screen.dart';

class AppRoutes {
  static const landing = '/';

  static final pages = [
    GetPage(name: landing, page: () => const LandingScreen()),
  ];
}
