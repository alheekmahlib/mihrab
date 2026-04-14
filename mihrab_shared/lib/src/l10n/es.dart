const Map<String, String> es = {
  // App
  'appName': 'Mihrab',
  'appDescription': 'Pantalla de mezquita para horarios de oración y hadices',

  // Prayer names
  'fajr': 'Fajr',
  'sunrise': 'Amanecer',
  'dhuhr': 'Dhuhr',
  'asr': 'Asr',
  'maghrib': 'Maghrib',
  'isha': 'Isha',
  'midnight': 'Medianoche',
  'lastThird': 'Último tercio',

  // Display modes
  'prayerTimes': 'Horarios de oración',
  'hadith': 'Hadiz',
  'combined': 'Horarios + Hadiz',
  'prayerQibla': 'Horarios + Qibla',
  'autoRotate': 'Rotación automática',

  // Onboarding
  'welcome': 'Bienvenido a Mihrab',
  'pairWithPhone': 'Vincular con teléfono',
  'manualSetup': 'Configuración manual',
  'scanQrCode': 'Escanea el código QR para vincular',
  'waitingForPairing': 'Esperando vinculación...',
  'selectCountry': 'Seleccionar país',
  'back': 'Atrás',
  'save': 'Guardar',
  'close': 'Cerrar',

  // Prayer times screen
  'nextPrayer': 'Próxima oración',
  'prayerTimeArrived': 'Es hora de',
  'remainingTime': 'Tiempo restante',

  // Hadith screen
  'hadithOfTheDay': 'Hadiz del día',
  'hadithNumber': 'Hadiz No.',
  'dailyHadith': 'Hadiz diario',

  // Qibla
  'qiblaDirection': 'Dirección de la Qibla',

  // Settings
  'settings': 'Configuración',
  'displayMode': 'Modo de visualización',
  'location': 'Ubicación',
  'calculationMethod': 'Método de cálculo',
  'madhab': 'Madhab',
  'shafi': 'Shafi\'i',
  'hanafi': 'Hanafi',
  'useEnglishNumbers': 'Usar números occidentales',
  'darkMode': 'Modo oscuro',
  'rePair': 'Revincular',
  'deleteDevice': 'Eliminar dispositivo',
  'deleteDeviceConfirm': '¿Está seguro de que desea eliminar este dispositivo?',
  'delete': 'Eliminar',
  'cancel': 'Cancelar',
  'resetPairingConfirm': 'Se eliminará la vinculación actual. ¿Continuar?',
  'autoRotateInterval': 'Intervalo de rotación',
  'selectMadhab': 'Seleccionar Madhab',
  'showQrCode': 'Mostrar código QR',
  'minutes': 'min',

  // Cardinal directions
  'north': 'Norte',
  'south': 'Sur',
  'east': 'Este',
  'west': 'Oeste',
  'northEast': 'Noreste',
  'northWest': 'Noroeste',
  'southEast': 'Sureste',
  'southWest': 'Suroeste',

  // Calculation methods
  'method_umm_al_qura': 'Umm Al-Qura',
  'method_mwl': 'Liga Mundial Musulmana',
  'method_egyptian': 'Autoridad General Egipcia',
  'method_karachi': 'Universidad de Ciencias Islámicas, Karachi',
  'method_dubai': 'Dubái',
  'method_kuwait': 'Kuwait',
  'method_qatar': 'Qatar',
  'method_singapore': 'Singapur',
  'method_turkey': 'Turquía',
  'method_tehran': 'Teherán',
  'method_north_america': 'Norteamérica (ISNA)',
  'method_other': 'Otro',

  // Hadith collections
  'collection_bukhari': 'Sahih Al-Bujari',
  'collection_muslim': 'Sahih Muslim',
  'collection_nasai': 'Sunan An-Nasai',
  'collection_abudawud': 'Sunan Abu Dawud',
  'collection_tirmidhi': 'Yami At-Tirmidhi',
  'collection_ibnmajah': 'Sunan Ibn Mayah',

  // Additional UI strings
  'language': 'Idioma',
  'selectLanguage': 'Seleccionar idioma',
  'retry': 'Reintentar',
  'adjustPrayerTimes': 'Ajustar horarios',
  'adjustPrayerTimesDesc': 'Ajustar horarios de oración en minutos (+ o -)',
  'savedSuccessfully': 'Guardado correctamente',
  'deviceNotFound': 'Dispositivo no encontrado',
  'error': 'Error',
  'noDeviceSelected': 'Ningún dispositivo seleccionado',
  'city': 'Ciudad',
  'country': 'País',
  'coordinates': 'Coordenadas',
  'detectLocation': 'Detectar ubicación',
  'detectingLocation': 'Detectando...',
  'locationNotSet':
      'Ubicación no establecida. Toque abajo para detectar automáticamente.',
  'locationPermissionRequired':
      'Permita el acceso a la ubicación en configuración',
  'locationError': 'Error al detectar ubicación',
  'noPairedDevices': 'No hay dispositivos vinculados',
  'scanQrToPair': 'Escanee el código QR de la pantalla del TV para vincular',
  'scannerInstructions': 'Apunte la cámara al código QR en la pantalla del TV',
  'screenLabel': 'Pantalla',
  'notSet': 'No establecido',
  'deviceNameTv': 'Mihrab TV',
  'registrationFailed': 'Error al registrar dispositivo',
  'renameDevice': 'Renombrar dispositivo',
  'deviceName': 'Nombre del dispositivo',

  // Web landing page
  'appDescriptionLong':
      'Mihrab es un sistema completo de pantalla de mezquita para mostrar horarios de oración, hadices proféticos y dirección de la Qibla. Controla tus pantallas de forma remota.',
  'goToDashboard': 'Panel de control',
  'features': 'Características',
  'featurePrayerTimes': 'Horarios de oración',
  'featurePrayerTimesDesc':
      'Horarios precisos con cuenta regresiva para la próxima oración',
  'featureHadith': 'Hadices proféticos',
  'featureHadithDesc':
      'Muestra hadices de las seis colecciones principales con rotación automática',
  'featureQibla': 'Dirección de la Qibla',
  'featureQiblaDesc':
      'Muestra la dirección de la Qibla en grados y punto cardinal',
  'featureMultiScreen': 'Multi-pantalla',
  'featureMultiScreenDesc': 'Controla múltiples pantallas desde un solo panel',
  'featureMultiLanguage': 'Multi-idioma',
  'featureMultiLanguageDesc': 'Soporte para 9 idiomas diferentes',
  'featureFullscreen': 'Pantalla completa',
  'featureFullscreenDesc':
      'Abre la pantalla de visualización en modo de pantalla completa desde tu navegador',
  'downloadApps': 'Descargar aplicaciones',
  'downloadTvApp': 'App de TV',
  'downloadDashboard': 'App de control',
  'scanWithCamera': 'Escanear con cámara',
  'enterTokenManually': 'Ingresar código manualmente',
  'pasteToken': 'Pegar código aquí',
  'tokenHint':
      'Ingresa el código de emparejamiento que aparece en la pantalla del TV',
  'openDisplay': 'Abrir pantalla',
  'enterFullscreen': 'Pantalla completa',
  'exitFullscreen': 'Salir de pantalla completa',
  'or': 'O',
  'hadithDisplayDuration': 'Duración de visualización del hadiz',
  'searchByCity': 'Buscar por nombre de ciudad',
  'enterCoordinates': 'Introducir coordenadas manualmente',
  'latitude': 'Latitud',
  'longitude': 'Longitud',
  'search': 'Buscar',

  // Hadith font size
  'hadithFontSize': 'Tamaño de Fuente del Hadiz',
  'fontSizeExtraSmall': 'Muy Pequeño',
  'fontSizeSmall': 'Pequeño',
  'fontSizeMedium': 'Medio',
  'fontSizeLarge': 'Grande',
  'fontSizeExtraLarge': 'Muy Grande',

  // Themes
  'themeLabel': 'Tema',
  'classicTheme': 'Clásico',
  'midnightBlueTheme': 'Azul Noche',
  'mosqueGreenTheme': 'Verde Mezquita',
};
