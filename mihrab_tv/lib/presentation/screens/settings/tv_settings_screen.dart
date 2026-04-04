import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../../data/services/ip_location_service.dart';
import '../../controllers/auto_rotate_controller.dart';
import '../../controllers/device_controller.dart';

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
                  event.logicalKey == LogicalKeyboardKey.goBack)) {
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
                      // Left: Settings header
                      Text(
                        AppStrings.settings,
                        style: AppTextStyles.tvHeading().copyWith(
                          color: context.theme.colorScheme.inversePrimary,
                        ),
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
                            Text(
                              AppStrings.settings,
                              style: AppTextStyles.tvHeading().copyWith(
                                color: context.theme.colorScheme.inversePrimary,
                              ),
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
    return SingleChildScrollView(
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

          // Theme toggle
          CustomSwitchListTile(
            title: AppStrings.darkMode,
            value: Get.isDarkMode,
            onChanged: (v) {
              Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
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
                            ? cityCountry
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
