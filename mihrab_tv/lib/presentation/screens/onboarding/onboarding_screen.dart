import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/routes.dart';
import '../../../data/services/ip_location_service.dart';
import '../../controllers/device_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _deviceCtrl = Get.find<DeviceController>();
  final _pageIndex = 0.obs; // 0=main, 1=qr, 2=manual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        switch (_pageIndex.value) {
          case 1:
            return _QrPairingView(
              deviceCtrl: _deviceCtrl,
              onBack: () => _pageIndex.value = 0,
            );
          case 2:
            return _ManualSetupView(
              deviceCtrl: _deviceCtrl,
              onBack: () => _pageIndex.value = 0,
            );
          default:
            return _MainChoiceView(
              onPairPhone: () async {
                await _deviceCtrl.generateAndRegisterDevice();
                _pageIndex.value = 1;
              },
              onManualSetup: () => _pageIndex.value = 2,
            );
        }
      }),
    );
  }
}

class _MainChoiceView extends StatelessWidget {
  final VoidCallback onPairPhone;
  final VoidCallback onManualSetup;

  const _MainChoiceView({
    required this.onPairPhone,
    required this.onManualSetup,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);
    final logoSize = (100 * scale).clamp(60.0, 120.0);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/mihrab_logo.svg',
              width: logoSize,
              height: logoSize,
              colorFilter: const ColorFilter.mode(
                AppColors.tealGreen,
                BlendMode.srcIn,
              ),
            ),
            Gap(20 * scale),
            Text(
              AppStrings.welcome,
              style: AppTextStyles.tvHeading(
                fontSize: (40 * scale).clamp(28, 48),
              ),
            ),
            Gap(6 * scale),
            Text(
              AppStrings.appDescription,
              style: AppTextStyles.tvBody(fontSize: (22 * scale).clamp(16, 28)),
            ),
            Gap(36 * scale),
            isPortrait
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 260 * scale,
                        child: ContainerButton(
                          title: AppStrings.pairWithPhone,
                          icon: Icon(Icons.qr_code_rounded, size: 28 * scale),
                          onPressed: onPairPhone,
                          autofocus: true,
                        ),
                      ),
                      Gap(16 * scale),
                      SizedBox(
                        width: 260 * scale,
                        child: ContainerButton(
                          title: AppStrings.manualSetup,
                          icon: Icon(Icons.settings_rounded, size: 28 * scale),
                          onPressed: onManualSetup,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 260 * scale,
                        child: ContainerButton(
                          title: AppStrings.pairWithPhone,
                          icon: Icon(Icons.qr_code_rounded, size: 28 * scale),
                          onPressed: onPairPhone,
                          autofocus: true,
                        ),
                      ),
                      Gap(24 * scale),
                      SizedBox(
                        width: 260 * scale,
                        child: ContainerButton(
                          title: AppStrings.manualSetup,
                          icon: Icon(Icons.settings_rounded, size: 28 * scale),
                          onPressed: onManualSetup,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _QrPairingView extends StatelessWidget {
  final DeviceController deviceCtrl;
  final VoidCallback onBack;

  const _QrPairingView({required this.deviceCtrl, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          onBack();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Center(
        child: Obx(() {
          final size = MediaQuery.sizeOf(context);
          final scale = (size.shortestSide / 800).clamp(0.5, 1.5);
          final qrSize = (220 * scale).clamp(140.0, 280.0);

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (deviceCtrl.registrationError.value.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12 * scale),
                    margin: EdgeInsets.only(bottom: 16 * scale),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 24 * scale,
                        ),
                        Gap(8 * scale),
                        Flexible(
                          child: Text(
                            deviceCtrl.registrationError.value,
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontSize: (14 * scale).clamp(10, 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TvFocusable(
                    autofocus: true,
                    onSelect: () async {
                      await deviceCtrl.generateAndRegisterDevice();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24 * scale,
                        vertical: 12 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tealGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppStrings.retry,
                        style: AppTextStyles.tvBody(
                          fontSize: (20 * scale).clamp(14, 24),
                        ).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Gap(16 * scale),
                ] else ...[
                  Text(
                    AppStrings.scanQrCode,
                    style: AppTextStyles.tvTitle(
                      fontSize: (30 * scale).clamp(20, 36),
                    ),
                  ),
                  Gap(24 * scale),
                  Container(
                    padding: EdgeInsets.all(18 * scale),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: 'mihrab://pair?token=${deviceCtrl.token.value}',
                      version: QrVersions.auto,
                      size: qrSize,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Gap(16 * scale),
                  SelectableText(
                    deviceCtrl.token.value,
                    style: AppTextStyles.bodySmall(
                      fontSize: (14 * scale).clamp(10, 18),
                    ).copyWith(fontFamily: 'monospace', letterSpacing: 2),
                  ),
                  Gap(12 * scale),
                  Text(
                    AppStrings.waitingForPairing,
                    style: AppTextStyles.tvBody(
                      fontSize: (22 * scale).clamp(16, 28),
                    ),
                  ),
                ],
                Gap(24 * scale),
                TvFocusable(
                  onSelect: onBack,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * scale,
                      vertical: 10 * scale,
                    ),
                    child: Text(
                      AppStrings.back,
                      style: AppTextStyles.tvBody(
                        fontSize: (22 * scale).clamp(16, 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ManualSetupView extends StatefulWidget {
  final DeviceController deviceCtrl;
  final VoidCallback onBack;

  const _ManualSetupView({required this.deviceCtrl, required this.onBack});

  @override
  State<_ManualSetupView> createState() => _ManualSetupViewState();
}

class _ManualSetupViewState extends State<_ManualSetupView> {
  // Location
  final _latitude = 0.0.obs;
  final _longitude = 0.0.obs;
  final _city = ''.obs;
  final _country = ''.obs;
  final _locationDetected = false.obs;
  final _detectingLocation = false.obs;
  final _locationError = ''.obs;

  // Country fallback
  final _countries = <Map<String, dynamic>>[].obs;
  final _selectedCountryIndex = (-1).obs;
  final _showCountryFallback = false.obs;

  // Settings
  final _selectedMethod = CalculationMethodType.ummAlQura.obs;
  final _selectedMadhab = 0.obs; // 0=Shafi, 1=Hanafi
  final _selectedDisplayMode = DisplayMode.prayerTimes.obs;
  final _selectedLanguage = 'ar'.obs;
  final _adjustments = <String, int>{}.obs;
  final _isLoading = true.obs;

  static const _languages = [
    ('ar', 'العربية'),
    ('en', 'English'),
    ('tr', 'Türkçe'),
    ('ur', 'اردو'),
    ('id', 'Bahasa Indonesia'),
    ('bn', 'বাংলা'),
    ('es', 'Español'),
    ('fil', 'Filipino'),
    ('so', 'Soomaali'),
  ];

  static List<(String, String)> get _prayers => [
    ('fajr', AppStrings.fajr),
    ('sunrise', AppStrings.sunrise),
    ('dhuhr', AppStrings.dhuhr),
    ('asr', AppStrings.asr),
    ('maghrib', AppStrings.maghrib),
    ('isha', AppStrings.isha),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadCountries();
    _isLoading.value = false;
    // Auto-detect location on entry
    _detectLocation();
  }

  Future<void> _loadCountries() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/madhabV2.json',
      );
      final data = (jsonDecode(jsonString) as List)
          .cast<Map<String, dynamic>>();
      _countries.value = data;
    } catch (_) {}
  }

  Future<void> _detectLocation() async {
    _detectingLocation.value = true;
    _locationError.value = '';
    try {
      final result = await IpLocationService.detect();
      _latitude.value = result.latitude;
      _longitude.value = result.longitude;
      _city.value = result.city;
      _country.value = result.country;
      _locationDetected.value = true;
      _showCountryFallback.value = false;

      // Auto-select calculation method based on detected country
      final method = await widget.deviceCtrl.getMethodForCountry(
        result.country,
      );
      _selectedMethod.value = method;
    } catch (_) {
      _locationError.value = AppStrings.locationError;
      _showCountryFallback.value = true;
    }
    _detectingLocation.value = false;
  }

  void _selectCountryFallback(int index) {
    _selectedCountryIndex.value = index;
    final c = _countries[index];
    _latitude.value = (c['lat'] as num?)?.toDouble() ?? 21.4225;
    _longitude.value = (c['lng'] as num?)?.toDouble() ?? 39.8262;
    _city.value = c['city'] as String? ?? '';
    _country.value = c['country'] as String? ?? '';
    _locationDetected.value = true;
  }

  Future<void> _saveAndContinue() async {
    if (!_locationDetected.value) return;

    await widget.deviceCtrl.saveManualSettings(
      latitude: _latitude.value,
      longitude: _longitude.value,
      city: _city.value,
      country: _country.value,
      calculationMethod: _selectedMethod.value,
      madhab: _selectedMadhab.value,
      displayMode: _selectedDisplayMode.value,
      language: _selectedLanguage.value,
      adjustments: Map<String, int>.from(_adjustments),
    );

    Get.offAllNamed(AppRoutes.display);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onBack();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale =
              (constraints.smallest.shortestSide > 0
                      ? constraints.biggest.shortestSide / 800
                      : MediaQuery.sizeOf(context).shortestSide / 800)
                  .clamp(0.5, 1.5);

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 60 * scale,
              vertical: 32 * scale,
            ),
            child: Obx(() {
              if (_isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.manualSetup,
                    style: AppTextStyles.tvTitle(
                      fontSize: (30 * scale).clamp(20, 36),
                    ),
                  ),
                  Gap(16 * scale),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Location ──
                          _sectionTitle(AppStrings.location, scale),
                          Gap(8 * scale),
                          _buildLocationSection(scale),
                          Gap(24 * scale),

                          // ── Calculation Method ──
                          _sectionTitle(AppStrings.calculationMethod, scale),
                          Gap(8 * scale),
                          _buildMethodSelector(scale),
                          Gap(24 * scale),

                          // ── Madhab ──
                          _sectionTitle(AppStrings.selectMadhab, scale),
                          Gap(8 * scale),
                          _buildMadhabSelector(scale),
                          Gap(24 * scale),

                          // ── Display Mode ──
                          _sectionTitle(AppStrings.displayMode, scale),
                          Gap(8 * scale),
                          _buildDisplayModeSelector(scale),
                          Gap(24 * scale),

                          // ── Language ──
                          _sectionTitle(AppStrings.language, scale),
                          Gap(8 * scale),
                          _buildLanguageSelector(scale),
                          Gap(24 * scale),

                          // ── Prayer Adjustments ──
                          _sectionTitle(AppStrings.adjustPrayerTimes, scale),
                          Gap(8 * scale),
                          _buildPrayerAdjustments(scale),
                          Gap(32 * scale),

                          // ── Save Button ──
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 220 * scale,
                              child: Obx(
                                () => ContainerButton(
                                  title: AppStrings.save,
                                  icon: Icon(
                                    Icons.check_rounded,
                                    size: 24 * scale,
                                  ),
                                  onPressed: _locationDetected.value
                                      ? _saveAndContinue
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Gap(24 * scale),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, double scale) {
    return Text(
      title,
      style: AppTextStyles.tvBody(fontSize: (22 * scale).clamp(16, 28))
          .copyWith(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildLocationSection(double scale) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 220 * scale,
                child: ContainerButton(
                  title: _detectingLocation.value
                      ? AppStrings.detectingLocation
                      : AppStrings.detectLocation,
                  icon: _detectingLocation.value
                      ? SizedBox(
                          width: 20 * scale,
                          height: 20 * scale,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.my_location_rounded, size: 22 * scale),
                  autofocus: true,
                  onPressed: _detectingLocation.value ? null : _detectLocation,
                ),
              ),
              Gap(16 * scale),
              if (_locationDetected.value)
                Text(
                  '${_city.value}, ${_country.value}',
                  style: AppTextStyles.tvBody(
                    fontSize: (18 * scale).clamp(14, 24),
                  ).copyWith(color: AppColors.tealGreen),
                ),
            ],
          ),
          if (_locationError.value.isNotEmpty) ...[
            Gap(8 * scale),
            Text(
              _locationError.value,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: (14 * scale).clamp(10, 18),
              ),
            ),
          ],
          // Country fallback list
          if (_showCountryFallback.value && _countries.isNotEmpty) ...[
            Gap(12 * scale),
            Text(
              AppStrings.selectCountry,
              style: AppTextStyles.tvBody(fontSize: (18 * scale).clamp(14, 24)),
            ),
            Gap(8 * scale),
            SizedBox(
              height: 80 * scale,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Padding(
                      padding: EdgeInsets.only(left: 8 * scale),
                      child: ContainerButton(
                        title: _countries[index]['country'] as String? ?? '',
                        isSelected: _selectedCountryIndex.value == index,
                        onPressed: () => _selectCountryFallback(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildMethodSelector(double scale) {
    return Wrap(
      spacing: 10 * scale,
      runSpacing: 10 * scale,
      children: CalculationMethodType.values.map((method) {
        return Obx(
          () => ContainerButton(
            title: method.localizedName,
            isSelected: _selectedMethod.value == method,
            onPressed: () => _selectedMethod.value = method,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMadhabSelector(double scale) {
    return Row(
      children: [
        Obx(
          () => SizedBox(
            width: 180 * scale,
            child: ContainerButton(
              title: AppStrings.madhabShafi,
              isSelected: _selectedMadhab.value == 0,
              onPressed: () => _selectedMadhab.value = 0,
            ),
          ),
        ),
        Gap(12 * scale),
        Obx(
          () => SizedBox(
            width: 180 * scale,
            child: ContainerButton(
              title: AppStrings.madhabHanafi,
              isSelected: _selectedMadhab.value == 1,
              onPressed: () => _selectedMadhab.value = 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayModeSelector(double scale) {
    return Wrap(
      spacing: 10 * scale,
      runSpacing: 10 * scale,
      children: DisplayMode.values.map((mode) {
        return Obx(
          () => ContainerButton(
            title: mode.localizedLabel,
            isSelected: _selectedDisplayMode.value == mode,
            onPressed: () => _selectedDisplayMode.value = mode,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguageSelector(double scale) {
    return Wrap(
      spacing: 10 * scale,
      runSpacing: 10 * scale,
      children: _languages.map((lang) {
        final (code, label) = lang;
        return Obx(
          () => ContainerButton(
            title: label,
            isSelected: _selectedLanguage.value == code,
            onPressed: () => _selectedLanguage.value = code,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrayerAdjustments(double scale) {
    return Obx(() {
      return Column(
        children: _prayers.map((entry) {
          final (key, label) = entry;
          final value = _adjustments[key] ?? 0;
          return Padding(
            padding: EdgeInsets.only(bottom: 6 * scale),
            child: Row(
              children: [
                SizedBox(
                  width: 100 * scale,
                  child: Text(
                    label,
                    style:
                        AppTextStyles.tvBody(
                          fontSize: (16 * scale).clamp(12, 22),
                        ).copyWith(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                  ),
                ),
                Gap(12 * scale),
                TvFocusable(
                  onSelect: value > -30
                      ? () {
                          _adjustments[key] = value - 1;
                        }
                      : null,
                  child: Container(
                    width: 40 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      size: 20 * scale,
                      color: value > -30
                          ? AppColors.tealGreen
                          : AppColors.darkText.withValues(alpha: .3),
                    ),
                  ),
                ),
                Gap(6 * scale),
                SizedBox(
                  width: 50 * scale,
                  child: Text(
                    '${value >= 0 ? '+' : ''}$value',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.tvBody(
                          fontSize: (16 * scale).clamp(12, 22),
                        ).copyWith(
                          color: value == 0
                              ? Theme.of(context).colorScheme.inversePrimary
                              : AppColors.tealGreen,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Gap(6 * scale),
                TvFocusable(
                  onSelect: value < 30
                      ? () {
                          _adjustments[key] = value + 1;
                        }
                      : null,
                  child: Container(
                    width: 40 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 20 * scale,
                      color: value < 30
                          ? AppColors.tealGreen
                          : AppColors.darkText.withValues(alpha: .3),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
