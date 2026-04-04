import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/web_device_repository_impl.dart';
import '../../domain/repositories/web_device_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final supabase = Supabase.instance.client;

    Get.lazyPut<WebDeviceRepository>(() => WebDeviceRepositoryImpl(supabase));
  }
}
