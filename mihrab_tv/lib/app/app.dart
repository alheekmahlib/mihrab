import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import 'bindings/initial_binding.dart';
import 'routes.dart';

class MihrabTvApp extends StatelessWidget {
  const MihrabTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock to landscape for TV
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final savedTheme = GetStorage().read<bool>('IS_DARK_MODE') ?? false;
    final savedLocale = GetStorage().read<String>('LOCALE') ?? 'ar';

    return GetMaterialApp(
      title: 'Mihrab',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(savedLocale),
      fallbackLocale: const Locale('ar'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: savedTheme ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fade,
    );
  }
}
