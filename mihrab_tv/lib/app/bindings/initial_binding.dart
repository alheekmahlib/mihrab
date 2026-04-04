import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/hadith_repository_impl.dart';
import '../../data/repositories/prayer_repository_impl.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../../presentation/controllers/auto_rotate_controller.dart';
import '../../presentation/controllers/device_controller.dart';
import '../../presentation/controllers/hadith_controller.dart';
import '../../presentation/controllers/prayer_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final storage = GetStorage();

    // Repositories
    Get.lazyPut<PrayerRepository>(
      () => PrayerRepositoryImpl(storage),
      fenix: true,
    );
    Get.lazyPut<HadithRepository>(() => HadithRepositoryImpl(), fenix: true);
    Get.lazyPut<DeviceRepository>(
      () => DeviceRepositoryImpl(Supabase.instance.client, storage),
      fenix: true,
    );

    // Controllers — permanent to survive route changes
    Get.put(
      DeviceController(
        Get.find<DeviceRepository>(),
        Get.find<PrayerRepository>(),
      ),
      permanent: true,
    );
    Get.put(PrayerController(Get.find<PrayerRepository>()), permanent: true);
    Get.put(HadithController(Get.find<HadithRepository>()), permanent: true);
    Get.lazyPut(() => AutoRotateController(), fenix: true);
  }
}
