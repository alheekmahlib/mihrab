import 'package:get/get.dart';

/// Calculation method types matching the adhan package
enum CalculationMethodType {
  ummAlQura('umm_al_qura', 'أم القرى'),
  muslimWorldLeague('mwl', 'رابطة العالم الإسلامي'),
  egyptian('egyptian', 'الهيئة المصرية العامة للمساحة'),
  karachi('karachi', 'جامعة العلوم الإسلامية - كراتشي'),
  dubai('dubai', 'دبي'),
  kuwait('kuwait', 'الكويت'),
  qatar('qatar', 'قطر'),
  singapore('singapore', 'سنغافورة'),
  turkey('turkey', 'تركيا'),
  northAmerica('north_america', 'أمريكا الشمالية'),
  other('other', 'أخرى');

  final String value;
  final String arabicName;

  const CalculationMethodType(this.value, this.arabicName);

  /// Localized name using GetX translations
  String get localizedName => 'method_$value'.tr;

  static CalculationMethodType fromValue(String value) {
    return CalculationMethodType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CalculationMethodType.ummAlQura,
    );
  }
}
