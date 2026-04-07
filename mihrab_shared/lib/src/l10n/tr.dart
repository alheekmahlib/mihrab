const Map<String, String> tr = {
  // App
  'appName': 'Mihrab',
  'appDescription': 'Namaz vakitleri ve hadisler için cami ekranı',

  // Prayer names
  'fajr': 'İmsak',
  'sunrise': 'Güneş',
  'dhuhr': 'Öğle',
  'asr': 'İkindi',
  'maghrib': 'Akşam',
  'isha': 'Yatsı',
  'midnight': 'Gece yarısı',
  'lastThird': 'Son üçte bir',

  // Display modes
  'prayerTimes': 'Namaz Vakitleri',
  'hadith': 'Hadis',
  'combined': 'Namaz Vakitleri + Hadis',
  'prayerQibla': 'Namaz Vakitleri + Kıble',
  'autoRotate': 'Otomatik döndürme',

  // Onboarding
  'welcome': 'Mihrab\'a hoş geldiniz',
  'pairWithPhone': 'Telefon ile eşleştir',
  'manualSetup': 'Manuel kurulum',
  'scanQrCode': 'Eşleştirmek için QR kodu tarayın',
  'waitingForPairing': 'Eşleşme bekleniyor...',
  'selectCountry': 'Ülke seçin',
  'back': 'Geri',
  'save': 'Kaydet',
  'close': 'Kapat',

  // Prayer times screen
  'nextPrayer': 'Sonraki namaz',
  'prayerTimeArrived': 'Namaz vakti geldi',
  'remainingTime': 'Kalan süre',

  // Hadith screen
  'hadithOfTheDay': 'Günün hadisi',
  'hadithNumber': 'Hadis No.',
  'dailyHadith': 'Günlük hadis',

  // Qibla
  'qiblaDirection': 'Kıble yönü',

  // Settings
  'settings': 'Ayarlar',
  'displayMode': 'Görüntüleme modu',
  'location': 'Konum',
  'calculationMethod': 'Hesaplama yöntemi',
  'madhab': 'Mezhep',
  'shafi': 'Şafii',
  'hanafi': 'Hanefi',
  'useEnglishNumbers': 'Latin rakamlarını kullan',
  'darkMode': 'Karanlık mod',
  'rePair': 'Yeniden eşleştir',
  'deleteDevice': 'Cihazı sil',
  'deleteDeviceConfirm': 'Bu cihazı silmek istediğinizden emin misiniz?',
  'delete': 'Sil',
  'cancel': 'İptal',
  'resetPairingConfirm': 'Mevcut eşleşme kaldırılacak. Devam edilsin mi?',
  'autoRotateInterval': 'Otomatik döndürme süresi',
  'selectMadhab': 'Mezhep seçin',
  'showQrCode': 'QR kodu göster',
  'minutes': 'dk',

  // Cardinal directions
  'north': 'Kuzey',
  'south': 'Güney',
  'east': 'Doğu',
  'west': 'Batı',
  'northEast': 'Kuzeydoğu',
  'northWest': 'Kuzeybatı',
  'southEast': 'Güneydoğu',
  'southWest': 'Güneybatı',

  // Calculation methods
  'method_umm_al_qura': 'Ümmül Kura',
  'method_mwl': 'Dünya İslam Birliği',
  'method_egyptian': 'Mısır Genel Otoritesi',
  'method_karachi': 'İslami Bilimler Üniversitesi, Karaçi',
  'method_dubai': 'Dubai',
  'method_kuwait': 'Kuveyt',
  'method_qatar': 'Katar',
  'method_singapore': 'Singapur',
  'method_turkey': 'Türkiye (Diyanet)',
  'method_tehran': 'Tahran',
  'method_north_america': 'Kuzey Amerika (ISNA)',
  'method_other': 'Diğer',

  // Hadith collections
  'collection_bukhari': 'Sahih-i Buhari',
  'collection_muslim': 'Sahih-i Müslim',
  'collection_nasai': 'Sünen-i Nesai',
  'collection_abudawud': 'Sünen-i Ebu Davud',
  'collection_tirmidhi': 'Cami-i Tirmizi',
  'collection_ibnmajah': 'Sünen-i İbn Mace',

  // Additional UI strings
  'language': 'Dil',
  'selectLanguage': 'Dil seçin',
  'retry': 'Tekrar dene',
  'adjustPrayerTimes': 'Vakitleri ayarla',
  'adjustPrayerTimesDesc':
      'Namaz vakitlerini dakika olarak ayarlayın (+ veya -)',
  'savedSuccessfully': 'Başarıyla kaydedildi',
  'deviceNotFound': 'Cihaz bulunamadı',
  'error': 'Hata',
  'noDeviceSelected': 'Cihaz seçilmedi',
  'city': 'Şehir',
  'country': 'Ülke',
  'coordinates': 'Koordinatlar',
  'detectLocation': 'Konum tespit et',
  'detectingLocation': 'Tespit ediliyor...',
  'locationNotSet':
      'Konum henüz belirlenmedi. Otomatik tespit için aşağıya dokunun.',
  'locationPermissionRequired': 'Ayarlardan konum erişimine izin verin',
  'locationError': 'Konum tespit hatası',
  'noPairedDevices': 'Eşleşmiş cihaz yok',
  'scanQrToPair': 'Eşleştirmek için TV ekranındaki QR kodu tarayın',
  'scannerInstructions': 'Kamerayı TV ekranındaki QR koda doğrultun',
  'screenLabel': 'Ekran',
  'notSet': 'Belirlenmedi',
  'deviceNameTv': 'Mihrab TV',
  'registrationFailed': 'Cihaz kaydı başarısız',
  'renameDevice': 'Cihazı yeniden adlandır',
  'deviceName': 'Cihaz adı',

  // Web landing page
  'appDescriptionLong':
      'Mihrab, namaz vakitlerini, hadisleri ve kıble yönünü gösteren eksiksiz bir cami ekran sistemidir. Ekranlarınızı her yerden uzaktan kontrol edin.',
  'goToDashboard': 'Kontrol Paneli',
  'features': 'Özellikler',
  'featurePrayerTimes': 'Namaz Vakitleri',
  'featurePrayerTimesDesc':
      'Bir sonraki namaz için geri sayım ile doğru namaz vakitleri',
  'featureHadith': 'Peygamber Hadisleri',
  'featureHadithDesc':
      'Altı büyük koleksiyondan otomatik dönüşlü hadis gösterimi',
  'featureQibla': 'Kıble Yönü',
  'featureQiblaDesc': 'Kıble yönünü derece ve ana yön olarak gösterin',
  'featureMultiScreen': 'Çoklu Ekran',
  'featureMultiScreenDesc': 'Tek bir panelden birden fazla ekranı kontrol edin',
  'featureMultiLanguage': 'Çok Dilli',
  'featureMultiLanguageDesc': '9 farklı dil desteği',
  'featureFullscreen': 'Tam Ekran Görüntüleme',
  'featureFullscreenDesc':
      'Tarayıcıdan tam ekran modunda görüntüleme ekranını açın',
  'downloadApps': 'Uygulamaları İndir',
  'downloadTvApp': 'TV Uygulaması',
  'downloadDashboard': 'Kontrol Uygulaması',
  'scanWithCamera': 'Kamera ile tara',
  'enterTokenManually': 'Kodu manuel girin',
  'pasteToken': 'Kodu buraya yapıştırın',
  'tokenHint': 'TV ekranında gösterilen eşleştirme kodunu girin',
  'openDisplay': 'Ekranı Aç',
  'enterFullscreen': 'Tam Ekran',
  'exitFullscreen': 'Tam Ekrandan Çık',
  'or': 'Veya',
  'hadithDisplayDuration': 'Hadis Gösterim Süresi',
  'searchByCity': 'Şehir adına göre ara',
  'enterCoordinates': 'Koordinatları manuel girin',
  'latitude': 'Enlem',
  'longitude': 'Boylam',
  'search': 'Ara',
};
