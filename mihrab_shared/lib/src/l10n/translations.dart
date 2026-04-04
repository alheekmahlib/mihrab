import 'package:get/get.dart';

import 'ar.dart' as ar_lang;
import 'bn.dart' as bn_lang;
import 'en.dart' as en_lang;
import 'es.dart' as es_lang;
import 'fil.dart' as fil_lang;
import 'id.dart' as id_lang;
import 'so.dart' as so_lang;
import 'tr.dart' as tr_lang;
import 'ur.dart' as ur_lang;

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': ar_lang.ar,
    'en': en_lang.en,
    'bn': bn_lang.bn,
    'es': es_lang.es,
    'id': id_lang.id,
    'fil': fil_lang.fil,
    'so': so_lang.so,
    'ur': ur_lang.ur,
    'tr': tr_lang.tr,
  };
}
