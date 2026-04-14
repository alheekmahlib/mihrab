const Map<String, String> en = {
  // App
  'appName': 'Mihrab',
  'appDescription': 'Mosque display for prayer times and hadiths',

  // Prayer names
  'fajr': 'Fajr',
  'sunrise': 'Sunrise',
  'dhuhr': 'Dhuhr',
  'asr': 'Asr',
  'maghrib': 'Maghrib',
  'isha': 'Isha',
  'midnight': 'Midnight',
  'lastThird': 'Last Third',

  // Display modes
  'prayerTimes': 'Prayer Times',
  'hadith': 'Hadith',
  'combined': 'Prayer Times + Hadith',
  'prayerQibla': 'Prayer Times + Qibla',
  'autoRotate': 'Auto Rotate',

  // Onboarding
  'welcome': 'Welcome to Mihrab',
  'pairWithPhone': 'Pair with Phone',
  'manualSetup': 'Manual Setup',
  'scanQrCode': 'Scan QR Code to Pair',
  'waitingForPairing': 'Waiting for pairing...',
  'selectCountry': 'Select Country',
  'back': 'Back',
  'save': 'Save',
  'close': 'Close',

  // Prayer times screen
  'nextPrayer': 'Next Prayer',
  'prayerTimeArrived': 'Time for',
  'remainingTime': 'Time Remaining',

  // Hadith screen
  'hadithOfTheDay': 'Hadith of the Day',
  'hadithNumber': 'Hadith No.',
  'dailyHadith': 'Daily Hadith',

  // Qibla
  'qiblaDirection': 'Qibla Direction',

  // Settings
  'settings': 'Settings',
  'displayMode': 'Display Mode',
  'location': 'Location',
  'calculationMethod': 'Calculation Method',
  'madhab': 'Madhab',
  'shafi': 'Shafi\'i',
  'hanafi': 'Hanafi',
  'useEnglishNumbers': 'Use English Numbers',
  'darkMode': 'Dark Mode',
  'rePair': 'Re-pair',
  'deleteDevice': 'Delete Device',
  'deleteDeviceConfirm': 'Are you sure you want to delete this device?',
  'delete': 'Delete',
  'cancel': 'Cancel',
  'resetPairingConfirm': 'Current pairing will be removed. Continue?',
  'autoRotateInterval': 'Auto Rotate Interval',
  'selectMadhab': 'Select Madhab',
  'showQrCode': 'Show QR Code',
  'minutes': 'min',

  // Cardinal directions
  'north': 'North',
  'south': 'South',
  'east': 'East',
  'west': 'West',
  'northEast': 'Northeast',
  'northWest': 'Northwest',
  'southEast': 'Southeast',
  'southWest': 'Southwest',

  // Calculation methods
  'method_umm_al_qura': 'Umm Al-Qura',
  'method_mwl': 'Muslim World League',
  'method_egyptian': 'Egyptian General Authority',
  'method_karachi': 'University of Islamic Sciences, Karachi',
  'method_dubai': 'Dubai',
  'method_kuwait': 'Kuwait',
  'method_qatar': 'Qatar',
  'method_singapore': 'Singapore',
  'method_turkey': 'Turkey',
  'method_tehran': 'Tehran',
  'method_north_america': 'North America (ISNA)',
  'method_other': 'Other',

  // Hadith collections
  'collection_bukhari': 'Sahih Al-Bukhari',
  'collection_muslim': 'Sahih Muslim',
  'collection_nasai': 'Sunan An-Nasa\'i',
  'collection_abudawud': 'Sunan Abu Dawud',
  'collection_tirmidhi': 'Jami\' At-Tirmidhi',
  'collection_ibnmajah': 'Sunan Ibn Majah',

  // Additional UI strings
  'language': 'Language',
  'selectLanguage': 'Select Language',
  'retry': 'Retry',
  'adjustPrayerTimes': 'Adjust Times',
  'adjustPrayerTimesDesc': 'Adjust prayer times by minutes (+ or -)',
  'savedSuccessfully': 'Saved successfully',
  'deviceNotFound': 'Device not found',
  'error': 'Error',
  'noDeviceSelected': 'No device selected',
  'city': 'City',
  'country': 'Country',
  'coordinates': 'Coordinates',
  'detectLocation': 'Detect Location',
  'detectingLocation': 'Detecting...',
  'locationNotSet': 'Location not set yet. Tap below to detect automatically.',
  'locationPermissionRequired': 'Please allow location access in settings',
  'locationError': 'Error detecting location',
  'noPairedDevices': 'No paired devices',
  'scanQrToPair': 'Scan QR code from TV screen to pair',
  'scannerInstructions': 'Point the camera at the QR code on the TV screen',
  'screenLabel': 'Screen',
  'notSet': 'Not set',
  'deviceNameTv': 'Mihrab TV',
  'registrationFailed': 'Device registration failed',
  'renameDevice': 'Rename Device',
  'deviceName': 'Device Name',

  // Web landing page
  'appDescriptionLong':
      'Mihrab is a complete mosque display system for showing prayer times, Prophetic hadiths, and Qibla direction. Control your screens remotely from anywhere.',
  'goToDashboard': 'Dashboard',
  'features': 'Features',
  'featurePrayerTimes': 'Prayer Times',
  'featurePrayerTimesDesc':
      'Accurate prayer times with countdown to next prayer',
  'featureHadith': 'Prophetic Hadiths',
  'featureHadithDesc':
      'Display hadiths from the six major collections with auto-rotation',
  'featureQibla': 'Qibla Direction',
  'featureQiblaDesc': 'Show Qibla direction in degrees and cardinal direction',
  'featureMultiScreen': 'Multi-Screen',
  'featureMultiScreenDesc': 'Control multiple screens from a single dashboard',
  'featureMultiLanguage': 'Multi-Language',
  'featureMultiLanguageDesc': 'Support for 9 different languages',
  'featureFullscreen': 'Fullscreen Display',
  'featureFullscreenDesc':
      'Open the display screen in fullscreen mode from your browser',
  'downloadApps': 'Download Apps',
  'downloadTvApp': 'TV App',
  'downloadDashboard': 'Dashboard App',
  'scanWithCamera': 'Scan with Camera',
  'enterTokenManually': 'Enter Token Manually',
  'pasteToken': 'Paste token here',
  'tokenHint': 'Enter the pairing code shown on the TV screen',
  'openDisplay': 'Open Display',
  'enterFullscreen': 'Fullscreen',
  'exitFullscreen': 'Exit Fullscreen',
  'or': 'Or',
  'hadithDisplayDuration': 'Hadith Display Duration',
  'searchByCity': 'Search by city name',
  'enterCoordinates': 'Enter coordinates manually',
  'latitude': 'Latitude',
  'longitude': 'Longitude',
  'search': 'Search',

  // Hadith font size
  'hadithFontSize': 'Hadith Font Size',
  'fontSizeExtraSmall': 'Extra Small',
  'fontSizeSmall': 'Small',
  'fontSizeMedium': 'Medium',
  'fontSizeLarge': 'Large',
  'fontSizeExtraLarge': 'Extra Large',

  // Themes
  'themeLabel': 'Theme',
  'classicTheme': 'Classic',
  'midnightBlueTheme': 'Midnight Blue',
  'mosqueGreenTheme': 'Mosque Green',
};
