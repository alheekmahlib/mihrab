import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import 'bindings/initial_binding.dart';
import 'routes.dart';

class MihrabWebApp extends StatelessWidget {
  const MihrabWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLocale = GetStorage().read<String>('LOCALE') ?? 'ar';

    return GetMaterialApp(
      title: 'محراب | Mihrab',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(savedLocale),
      fallbackLocale: const Locale('ar'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.landing,
    );
  }
}
