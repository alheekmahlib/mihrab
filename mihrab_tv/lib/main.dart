import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('ar');

  // TODO: Replace with your Supabase credentials
  await Supabase.initialize(
    url: 'https://umkarcgmstwdaufnsbom.supabase.co',
    anonKey: 'sb_publishable_f9RSLwXtgs4ZP0DA9QNkiA_SErXl8PU',
  );

  runApp(const MihrabTvApp());
}
