import 'package:get/get.dart';

import '../presentation/screens/device_settings/device_settings_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/scanner/scanner_screen.dart';

class AppRoutes {
  static const home = '/';
  static const scanner = '/scanner';
  static const deviceSettings = '/device-settings';

  static final pages = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: scanner, page: () => const ScannerScreen()),
    GetPage(name: deviceSettings, page: () => const DeviceSettingsScreen()),
  ];
}
