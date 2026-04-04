import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/dashboard_device_repository_impl.dart';
import '../../domain/repositories/dashboard_device_repository.dart';
import '../../presentation/controllers/dashboard_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final supabase = Supabase.instance.client;

    Get.lazyPut<DashboardDeviceRepository>(
      () => DashboardDeviceRepositoryImpl(supabase),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find<DashboardDeviceRepository>()),
    );
  }
}
