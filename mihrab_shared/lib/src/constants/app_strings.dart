import 'package:get/get.dart';

/// App string constants — uses GetX .tr for localization
class AppStrings {
  AppStrings._();

  static String get appName => 'appName'.tr;

  // Prayer names
  static String get fajr => 'fajr'.tr;
  static String get sunrise => 'sunrise'.tr;
  static String get dhuhr => 'dhuhr'.tr;
  static String get asr => 'asr'.tr;
  static String get maghrib => 'maghrib'.tr;
  static String get isha => 'isha'.tr;
  static String get midnight => 'midnight'.tr;
  static String get lastThird => 'lastThird'.tr;

  // Display modes
  static String get prayerTimes => 'prayerTimes'.tr;
  static String get hadith => 'hadith'.tr;
  static String get combined => 'combined'.tr;
  static String get prayerQibla => 'prayerQibla'.tr;
  static String get autoRotate => 'autoRotate'.tr;

  // Onboarding
  static String get welcome => 'welcome'.tr;
  static String get appDescription => 'appDescription'.tr;
  static String get pairWithPhone => 'pairWithPhone'.tr;
  static String get manualSetup => 'manualSetup'.tr;
  static String get scanQrCode => 'scanQrCode'.tr;
  static String get waitingForPairing => 'waitingForPairing'.tr;
  static String get selectCountry => 'selectCountry'.tr;
  static String get back => 'back'.tr;
  static String get save => 'save'.tr;
  static String get close => 'close'.tr;

  // Prayer times screen
  static String get nextPrayer => 'nextPrayer'.tr;
  static String get prayerTimeArrived => 'prayerTimeArrived'.tr;
  static String get remainingTime => 'remainingTime'.tr;

  // Hadith screen
  static String get hadithOfTheDay => 'hadithOfTheDay'.tr;
  static String get hadithNumber => 'hadithNumber'.tr;
  static String get dailyHadith => 'dailyHadith'.tr;

  // Qibla
  static String get qiblaDirection => 'qiblaDirection'.tr;

  // Settings
  static String get settings => 'settings'.tr;
  static String get displayMode => 'displayMode'.tr;
  static String get location => 'location'.tr;
  static String get calculationMethod => 'calculationMethod'.tr;
  static String get madhab => 'madhab'.tr;
  static String get shafi => 'shafi'.tr;
  static String get hanafi => 'hanafi'.tr;
  static String get madhabShafi => 'shafi'.tr;
  static String get madhabHanafi => 'hanafi'.tr;
  static String get useEnglishNumbers => 'useEnglishNumbers'.tr;
  static String get darkMode => 'darkMode'.tr;
  static String get rePair => 'rePair'.tr;
  static String get deleteDevice => 'deleteDevice'.tr;
  static String get deleteDeviceConfirm => 'deleteDeviceConfirm'.tr;
  static String get delete => 'delete'.tr;
  static String get cancel => 'cancel'.tr;
  static String get resetPairingConfirm => 'resetPairingConfirm'.tr;
  static String get autoRotateInterval => 'autoRotateInterval'.tr;
  static String get selectMadhab => 'selectMadhab'.tr;
  static String get showQrCode => 'showQrCode'.tr;
  static String get minutes => 'minutes'.tr;

  // Cardinal directions
  static String get north => 'north'.tr;
  static String get south => 'south'.tr;
  static String get east => 'east'.tr;
  static String get west => 'west'.tr;
  static String get northEast => 'northEast'.tr;
  static String get northWest => 'northWest'.tr;
  static String get southEast => 'southEast'.tr;
  static String get southWest => 'southWest'.tr;

  // Additional UI strings
  static String get language => 'language'.tr;
  static String get selectLanguage => 'selectLanguage'.tr;
  static String get retry => 'retry'.tr;
  static String get adjustPrayerTimes => 'adjustPrayerTimes'.tr;
  static String get adjustPrayerTimesDesc => 'adjustPrayerTimesDesc'.tr;
  static String get savedSuccessfully => 'savedSuccessfully'.tr;
  static String get deviceNotFound => 'deviceNotFound'.tr;
  static String get error => 'error'.tr;
  static String get noDeviceSelected => 'noDeviceSelected'.tr;
  static String get city => 'city'.tr;
  static String get country => 'country'.tr;
  static String get coordinates => 'coordinates'.tr;
  static String get detectLocation => 'detectLocation'.tr;
  static String get detectingLocation => 'detectingLocation'.tr;
  static String get locationNotSet => 'locationNotSet'.tr;
  static String get locationPermissionRequired =>
      'locationPermissionRequired'.tr;
  static String get locationError => 'locationError'.tr;
  static String get noPairedDevices => 'noPairedDevices'.tr;
  static String get scanQrToPair => 'scanQrToPair'.tr;
  static String get scannerInstructions => 'scannerInstructions'.tr;
  static String get screenLabel => 'screenLabel'.tr;
  static String get notSet => 'notSet'.tr;
  static String get deviceNameTv => 'deviceNameTv'.tr;
  static String get registrationFailed => 'registrationFailed'.tr;
  static String get renameDevice => 'renameDevice'.tr;
  static String get deviceName => 'deviceName'.tr;

  // Web landing page
  static String get appDescriptionLong => 'appDescriptionLong'.tr;
  static String get goToDashboard => 'goToDashboard'.tr;
  static String get features => 'features'.tr;
  static String get featurePrayerTimes => 'featurePrayerTimes'.tr;
  static String get featurePrayerTimesDesc => 'featurePrayerTimesDesc'.tr;
  static String get featureHadith => 'featureHadith'.tr;
  static String get featureHadithDesc => 'featureHadithDesc'.tr;
  static String get featureQibla => 'featureQibla'.tr;
  static String get featureQiblaDesc => 'featureQiblaDesc'.tr;
  static String get featureMultiScreen => 'featureMultiScreen'.tr;
  static String get featureMultiScreenDesc => 'featureMultiScreenDesc'.tr;
  static String get featureMultiLanguage => 'featureMultiLanguage'.tr;
  static String get featureMultiLanguageDesc => 'featureMultiLanguageDesc'.tr;
  static String get featureFullscreen => 'featureFullscreen'.tr;
  static String get featureFullscreenDesc => 'featureFullscreenDesc'.tr;
  static String get downloadApps => 'downloadApps'.tr;
  static String get downloadTvApp => 'downloadTvApp'.tr;
  static String get downloadDashboard => 'downloadDashboard'.tr;
  static String get scanWithCamera => 'scanWithCamera'.tr;
  static String get enterTokenManually => 'enterTokenManually'.tr;
  static String get pasteToken => 'pasteToken'.tr;
  static String get tokenHint => 'tokenHint'.tr;
  static String get openDisplay => 'openDisplay'.tr;
  static String get enterFullscreen => 'enterFullscreen'.tr;
  static String get exitFullscreen => 'exitFullscreen'.tr;
}
