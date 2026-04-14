import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../../data/services/geocoding_service.dart';
import '../../../data/services/ip_location_service.dart';
import '../../controllers/auto_rotate_controller.dart';
import '../../controllers/device_controller.dart';
import '../../controllers/hadith_controller.dart';

class TvSettingsScreen extends StatelessWidget {
  const TvSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceCtrl = Get.find<DeviceController>();
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Get.back();
      },
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.escape ||
                  event.logicalKey == LogicalKeyboardKey.goBack ||
                  event.logicalKey == LogicalKeyboardKey.browserBack)) {
            Get.back();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
            child: isPortrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button + Settings header
                      Row(
                        children: [
                          TvFocusable(
                            autofocus: true,
                            borderRadius: BorderRadius.circular(24),
                            padding: const EdgeInsets.all(8),
                            onSelect: () => Get.back(),
                            child: Icon(
                              Icons.arrow_back,
                              color: context.theme.colorScheme.inversePrimary,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            AppStrings.settings,
                            style: AppTextStyles.tvHeading().copyWith(
                              color: context.theme.colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Obx(
                        () => Text(
                          deviceCtrl.settings.value?.city ?? '',
                          style: AppTextStyles.tvBody().copyWith(
                            color: context.theme.colorScheme.inversePrimary
                                .withValues(alpha: .6),
                          ),
                        ),
                      ),
                      const Gap(40),
                      Expanded(child: _SettingsContent(deviceCtrl: deviceCtrl)),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Settings header
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TvFocusable(
                                  autofocus: true,
                                  borderRadius: BorderRadius.circular(24),
                                  padding: const EdgeInsets.all(8),
                                  onSelect: () => Get.back(),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: context
                                        .theme
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                const Gap(12),
                                Text(
                                  AppStrings.settings,
                                  style: AppTextStyles.tvHeading().copyWith(
                                    color: context
                                        .theme
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            Obx(
                              () => Text(
                                deviceCtrl.settings.value?.city ?? '',
                                style: AppTextStyles.tvBody().copyWith(
                                  color: context
                                      .theme
                                      .colorScheme
                                      .inversePrimary
                                      .withValues(alpha: .6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(40),
                      Expanded(child: _SettingsContent(deviceCtrl: deviceCtrl)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _SettingsContent({required this.deviceCtrl});

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

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location
            _LocationSection(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Calculation method
            Text(
              AppStrings.calculationMethod,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(12),
            _CalculationMethodSelector(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Display mode
            Text(
              AppStrings.displayMode,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(16),
            _DisplayModeSelector(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Auto-rotate interval (when auto-rotate mode)
            Obx(() {
              if (deviceCtrl.displayMode.value != DisplayMode.autoRotate) {
                return const SizedBox.shrink();
              }
              return _AutoRotateSettings();
            }),

            // Hadith interval (when hadith or combined mode)
            Obx(() {
              final mode = deviceCtrl.displayMode.value;
              if (mode != DisplayMode.hadith && mode != DisplayMode.combined) {
                return const SizedBox.shrink();
              }
              return _HadithIntervalSettings(deviceCtrl: deviceCtrl);
            }),

            // Hadith font size (when hadith or combined mode)
            Obx(() {
              final mode = deviceCtrl.displayMode.value;
              if (mode != DisplayMode.hadith && mode != DisplayMode.combined) {
                return const SizedBox.shrink();
              }
              return _HadithFontSizeSettings(deviceCtrl: deviceCtrl);
            }),

            // Madhab
            Text(
              AppStrings.selectMadhab,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(12),
            _MadhabSelector(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Language
            Text(
              AppStrings.language,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(12),
            _LanguageSelector(deviceCtrl: deviceCtrl, languages: _languages),
            const Gap(32),

            // Prayer time adjustments
            Text(
              AppStrings.adjustPrayerTimes,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(12),
            _PrayerAdjustments(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Theme selector
            Text(
              AppStrings.themeLabel,
              style: AppTextStyles.tvTitle().copyWith(
                color: context.theme.colorScheme.inversePrimary,
              ),
            ),
            const Gap(12),
            _ThemeSelector(deviceCtrl: deviceCtrl),
            const Gap(32),

            // Theme toggle
            CustomSwitchListTile(
              title: AppStrings.darkMode,
              value: Get.isDarkMode,
              onChanged: (v) {
                final themeName = deviceCtrl.settings.value?.theme ?? 'classic';
                Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                Get.changeTheme(AppTheme.getTheme(themeName, v));
                GetStorage().write('IS_DARK_MODE', v);
              },
            ),
            const Gap(16),

            // Re-pair button
            SizedBox(
              width: 250,
              child: ContainerButton(
                title: AppStrings.rePair,
                icon: const Icon(
                  Icons.link_off_rounded,
                  size: 28,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      title: Text(AppStrings.rePair),
                      content: Text(AppStrings.resetPairingConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(AppStrings.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            deviceCtrl.resetDevice();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: Text(AppStrings.rePair),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSection extends StatefulWidget {
  final DeviceController deviceCtrl;
  const _LocationSection({required this.deviceCtrl});

  @override
  State<_LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<_LocationSection> {
  final _detecting = false.obs;

  // City search
  final _searchController = TextEditingController();
  final _searchResults = <GeocodingResult>[].obs;
  final _isSearching = false.obs;

  // Manual coordinates
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _showManualEntry = false.obs;

  Future<void> _redetect() async {
    _detecting.value = true;
    try {
      final result = await IpLocationService.detect();
      final current = widget.deviceCtrl.settings.value;
      if (current != null) {
        await widget.deviceCtrl.saveManualSettings(
          latitude: result.latitude,
          longitude: result.longitude,
          city: result.city,
          country: result.country,
          calculationMethod:
              current.calculationMethod ??
              CalculationMethodType.ummAlQura.value,
          madhab: current.madhab ?? 0,
        );
      }
    } catch (_) {
      if (mounted) {
        Get.snackbar(
          AppStrings.error,
          AppStrings.locationError,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    _detecting.value = false;
  }

  Future<void> _searchCity() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    _isSearching.value = true;
    _searchResults.clear();
    try {
      final results = await GeocodingService.search(query);
      _searchResults.value = results;
    } catch (_) {
      _searchResults.clear();
    }
    _isSearching.value = false;
  }

  void _selectSearchResult(GeocodingResult result) {
    final parts = result.displayName.split(', ');
    final city = parts.isNotEmpty ? parts.first : '';
    final country = parts.length > 1 ? parts.last : '';
    final current = widget.deviceCtrl.settings.value;
    if (current != null) {
      widget.deviceCtrl.saveManualSettings(
        latitude: result.latitude,
        longitude: result.longitude,
        city: city,
        country: country,
        calculationMethod:
            current.calculationMethod ?? CalculationMethodType.ummAlQura.value,
        madhab: current.madhab ?? 0,
      );
    }
    _searchResults.clear();
    _searchController.clear();
  }

  void _applyManualCoords() {
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    if (lat == null || lng == null) return;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return;
    final current = widget.deviceCtrl.settings.value;
    if (current != null) {
      widget.deviceCtrl.saveManualSettings(
        latitude: lat,
        longitude: lng,
        city: '',
        country: '',
        calculationMethod:
            current.calculationMethod ?? CalculationMethodType.ummAlQura.value,
        madhab: current.madhab ?? 0,
      );
    }
    _showManualEntry.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.location,
          style: AppTextStyles.tvTitle().copyWith(
            color: context.theme.colorScheme.inversePrimary,
          ),
        ),
        const Gap(12),
        Obx(() {
          final s = widget.deviceCtrl.settings.value;
          final cityCountry = [
            if (s?.city != null && s!.city!.isNotEmpty) s.city!,
            if (s?.country != null && s!.country!.isNotEmpty) s.country!,
          ].join(', ');
          final coordsText =
              (s?.latitude != null &&
                  s?.longitude != null &&
                  (s!.latitude != 0 || s.longitude != 0))
              ? '(${s.latitude!.toStringAsFixed(4)}, ${s.longitude!.toStringAsFixed(4)})'
              : '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.tealGreen,
                    size: 24,
                  ),
                  const Gap(8),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        cityCountry.isNotEmpty
                            ? '$cityCountry $coordsText'
                            : coordsText.isNotEmpty
                            ? coordsText
                            : AppStrings.locationNotSet,
                        style: AppTextStyles.tvBody().copyWith(
                          color: context.theme.colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),

              // IP detect button
              SizedBox(
                width: 200,
                child: ContainerButton(
                  title: _detecting.value
                      ? AppStrings.detectingLocation
                      : AppStrings.detectLocation,
                  icon: _detecting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded, size: 20),
                  autofocus: true,
                  onPressed: _detecting.value ? null : _redetect,
                ),
              ),
              const Gap(20),

              // ── City search ──
              Text(
                AppStrings.searchByCity,
                style: AppTextStyles.tvBody().copyWith(
                  color: context.theme.colorScheme.inversePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchByCity,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.tealGreen,
                              width: 2,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _searchCity(),
                      ),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 120,
                    child: ContainerButton(
                      title: _isSearching.value ? '...' : AppStrings.search,
                      icon: _isSearching.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search_rounded, size: 20),
                      onPressed: _isSearching.value ? null : _searchCity,
                    ),
                  ),
                ],
              ),
              // Search results
              if (_searchResults.isNotEmpty) ...[
                const Gap(8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.tealGreen.withValues(alpha: .3),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return TvFocusable(
                        onSelect: () => _selectSearchResult(result),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(
                            result.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const Gap(16),

              // ── Manual coordinates toggle ──
              TvFocusable(
                onSelect: () =>
                    _showManualEntry.value = !_showManualEntry.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showManualEntry.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.tealGreen,
                      size: 22,
                    ),
                    const Gap(4),
                    Text(
                      AppStrings.enterCoordinates,
                      style: AppTextStyles.tvBody().copyWith(
                        color: AppColors.tealGreen,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showManualEntry.value) ...[
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _latController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            labelText: AppStrings.latitude,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.tealGreen,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _lngController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            labelText: AppStrings.longitude,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.tealGreen,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    SizedBox(
                      width: 100,
                      child: ContainerButton(
                        title: AppStrings.save,
                        onPressed: _applyManualCoords,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}

class _CalculationMethodSelector extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _CalculationMethodSelector({required this.deviceCtrl});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: CalculationMethodType.values.map((method) {
        return Obx(() {
          final current = CalculationMethodType.fromValue(
            deviceCtrl.settings.value?.calculationMethod ?? 'umm_al_qura',
          );
          return ContainerButton(
            title: method.localizedName,
            isSelected: current == method,
            onPressed: () {
              final s = deviceCtrl.settings.value;
              if (s != null) {
                deviceCtrl.saveManualSettings(
                  latitude: s.latitude ?? 0,
                  longitude: s.longitude ?? 0,
                  city: s.city ?? '',
                  country: s.country ?? '',
                  calculationMethod: method,
                  madhab: s.madhab ?? 0,
                );
              }
            },
          );
        });
      }).toList(),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final DeviceController deviceCtrl;
  final List<(String, String)> languages;
  const _LanguageSelector({required this.deviceCtrl, required this.languages});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: languages.map((lang) {
        final (code, label) = lang;
        return Obx(() {
          final currentLang =
              deviceCtrl.settings.value?.language ??
              Get.locale?.languageCode ??
              'ar';
          return ContainerButton(
            title: label,
            isSelected: currentLang == code,
            onPressed: () {
              final s = deviceCtrl.settings.value;
              if (s != null) {
                deviceCtrl.saveManualSettings(
                  latitude: s.latitude ?? 0,
                  longitude: s.longitude ?? 0,
                  city: s.city ?? '',
                  country: s.country ?? '',
                  calculationMethod:
                      s.calculationMethod ??
                      CalculationMethodType.ummAlQura.value,
                  madhab: s.madhab ?? 0,
                  language: code,
                );
              }
            },
          );
        });
      }).toList(),
    );
  }
}

class _DisplayModeSelector extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _DisplayModeSelector({required this.deviceCtrl});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: DisplayMode.values.map((mode) {
        return Obx(
          () => ContainerButton(
            title: mode.localizedLabel,
            isSelected: deviceCtrl.displayMode.value == mode,
            autofocus: mode == DisplayMode.prayerTimes,
            onPressed: () => deviceCtrl.changeDisplayMode(mode),
          ),
        );
      }).toList(),
    );
  }
}

class _MadhabSelector extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _MadhabSelector({required this.deviceCtrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => SizedBox(
            width: 180,
            child: ContainerButton(
              title: AppStrings.shafi,
              isSelected: (deviceCtrl.settings.value?.madhab ?? 0) == 0,
              onPressed: () {
                final current = deviceCtrl.settings.value;
                if (current != null) {
                  deviceCtrl.saveManualSettings(
                    latitude: current.latitude ?? 0,
                    longitude: current.longitude ?? 0,
                    city: current.city ?? '',
                    country: current.country ?? '',
                    calculationMethod:
                        current.calculationMethod ??
                        CalculationMethodType.ummAlQura.value,
                    madhab: 0,
                  );
                }
              },
            ),
          ),
        ),
        const Gap(12),
        Obx(
          () => SizedBox(
            width: 180,
            child: ContainerButton(
              title: AppStrings.hanafi,
              isSelected: (deviceCtrl.settings.value?.madhab ?? 0) == 1,
              onPressed: () {
                final current = deviceCtrl.settings.value;
                if (current != null) {
                  deviceCtrl.saveManualSettings(
                    latitude: current.latitude ?? 0,
                    longitude: current.longitude ?? 0,
                    city: current.city ?? '',
                    country: current.country ?? '',
                    calculationMethod:
                        current.calculationMethod ??
                        CalculationMethodType.ummAlQura.value,
                    madhab: 1,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AutoRotateSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AutoRotateController>()) {
      Get.put(AutoRotateController());
    }
    final autoCtrl = Get.find<AutoRotateController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.autoRotateInterval,
          style: AppTextStyles.tvTitle().copyWith(
            color: context.theme.colorScheme.inversePrimary,
          ),
        ),
        const Gap(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [3, 5, 10, 15].map((mins) {
              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Obx(
                  () => SizedBox(
                    width: 120,
                    child: ContainerButton(
                      title: '$mins ${AppStrings.minutes}',
                      isSelected: autoCtrl.intervalMinutes.value == mins,
                      onPressed: () => autoCtrl.updateInterval(mins),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Gap(32),
      ],
    );
  }
}

class _HadithIntervalSettings extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _HadithIntervalSettings({required this.deviceCtrl});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HadithController>()) return const SizedBox.shrink();
    final hadithCtrl = Get.find<HadithController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.hadithDisplayDuration,
          style: AppTextStyles.tvTitle().copyWith(
            color: context.theme.colorScheme.inversePrimary,
          ),
        ),
        const Gap(12),
        Obx(() {
          final value = hadithCtrl.rotationInterval.value;
          return Row(
            children: [
              TvFocusable(
                onSelect: value > 1
                    ? () {
                        final newVal = value - 1;
                        hadithCtrl.updateRotationInterval(newVal);
                        _saveInterval(newVal);
                      }
                    : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.remove,
                    color: value > 1
                        ? AppColors.tealGreen
                        : AppColors.darkText.withValues(alpha: .3),
                  ),
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 80,
                child: Text(
                  '$value ${AppStrings.minutes}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.tvBody().copyWith(
                    color: AppColors.tealGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(8),
              TvFocusable(
                onSelect: value < 60
                    ? () {
                        final newVal = value + 1;
                        hadithCtrl.updateRotationInterval(newVal);
                        _saveInterval(newVal);
                      }
                    : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add,
                    color: value < 60
                        ? AppColors.tealGreen
                        : AppColors.darkText.withValues(alpha: .3),
                  ),
                ),
              ),
            ],
          );
        }),
        const Gap(32),
      ],
    );
  }

  void _saveInterval(int minutes) {
    deviceCtrl.updateHadithInterval(minutes);
  }
}

class _HadithFontSizeSettings extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _HadithFontSizeSettings({required this.deviceCtrl});

  static const _labels = {
    1: 'fontSizeExtraSmall',
    2: 'fontSizeSmall',
    3: 'fontSizeMedium',
    4: 'fontSizeLarge',
    5: 'fontSizeExtraLarge',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.hadithFontSize,
          style: AppTextStyles.tvTitle().copyWith(
            color: context.theme.colorScheme.inversePrimary,
          ),
        ),
        const Gap(12),
        Obx(() {
          final value = deviceCtrl.settings.value?.hadithFontSize ?? 3;
          return Row(
            children: [
              TvFocusable(
                onSelect: value > 1
                    ? () => deviceCtrl.updateHadithFontSize(value - 1)
                    : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.remove,
                    color: value > 1
                        ? AppColors.tealGreen
                        : AppColors.darkText.withValues(alpha: .3),
                  ),
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 120,
                child: Text(
                  (_labels[value] ?? 'fontSizeMedium').tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.tvBody().copyWith(
                    color: AppColors.tealGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(8),
              TvFocusable(
                onSelect: value < 5
                    ? () => deviceCtrl.updateHadithFontSize(value + 1)
                    : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add,
                    color: value < 5
                        ? AppColors.tealGreen
                        : AppColors.darkText.withValues(alpha: .3),
                  ),
                ),
              ),
            ],
          );
        }),
        const Gap(32),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _ThemeSelector({required this.deviceCtrl});

  static const _themes = [
    (
      'classic',
      AppColors.whiteCream,
      AppColors.primaryDarkGreen,
      AppColors.darkText,
    ),
    (
      'midnight_blue',
      AppColors.midnightNavy,
      AppColors.midnightBlue,
      AppColors.midnightText,
    ),
    (
      'mosque_green',
      AppColors.mosqueForest,
      AppColors.mosqueEmerald,
      AppColors.mosqueCream,
    ),
  ];

  static String _themeName(String key) {
    switch (key) {
      case 'midnight_blue':
        return AppStrings.midnightBlueTheme;
      case 'mosque_green':
        return AppStrings.mosqueGreenTheme;
      case 'classic':
      default:
        return AppStrings.classicTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = deviceCtrl.settings.value?.theme ?? 'classic';
      return Row(
        children: _themes.map((theme) {
          final (key, bg, accent, text) = theme;
          final isSelected = current == key;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TvFocusable(
              onSelect: () => deviceCtrl.updateTheme(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 140,
                height: 90,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldAmber
                        : Colors.transparent,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldAmber.withValues(alpha: .3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      _themeName(key),
                      style: TextStyle(
                        color: text,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _PrayerAdjustments extends StatelessWidget {
  final DeviceController deviceCtrl;
  const _PrayerAdjustments({required this.deviceCtrl});

  static List<(String, String)> get _prayers => [
    ('fajr', AppStrings.fajr),
    ('sunrise', AppStrings.sunrise),
    ('dhuhr', AppStrings.dhuhr),
    ('asr', AppStrings.asr),
    ('maghrib', AppStrings.maghrib),
    ('isha', AppStrings.isha),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final adj = Map<String, int>.from(
        deviceCtrl.settings.value?.adjustments ?? {},
      );
      return Column(
        children: _prayers.map((entry) {
          final (key, label) = entry;
          final value = adj[key] ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    label,
                    style: AppTextStyles.tvBody().copyWith(
                      color: context.theme.colorScheme.inversePrimary,
                    ),
                  ),
                ),
                const Gap(16),
                TvFocusable(
                  onSelect: value > -30
                      ? () {
                          adj[key] = value - 1;
                          deviceCtrl.updateAdjustments(
                            Map<String, int>.from(adj),
                          );
                        }
                      : null,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      color: value > -30
                          ? AppColors.tealGreen
                          : AppColors.darkText.withValues(alpha: .3),
                    ),
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${value >= 0 ? '+' : ''}$value',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.tvBody().copyWith(
                      color: value == 0
                          ? context.theme.colorScheme.inversePrimary
                          : AppColors.tealGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(8),
                TvFocusable(
                  onSelect: value < 30
                      ? () {
                          adj[key] = value + 1;
                          deviceCtrl.updateAdjustments(
                            Map<String, int>.from(adj),
                          );
                        }
                      : null,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
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
