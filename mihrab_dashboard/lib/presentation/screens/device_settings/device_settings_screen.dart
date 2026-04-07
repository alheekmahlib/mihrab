import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/dashboard_controller.dart';

class DeviceSettingsScreen extends StatefulWidget {
  const DeviceSettingsScreen({super.key});

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  final ctrl = Get.find<DashboardController>();

  late DisplayMode _selectedDisplayMode;
  late CalculationMethodType _selectedMethod;
  late int _selectedMadhab;
  double _latitude = 0;
  double _longitude = 0;
  String _city = '';
  String _country = '';
  bool _hasChanges = false;
  bool _detectingLocation = false;
  late Map<String, int> _adjustments;
  late String _selectedLanguage;
  bool _isDarkMode = false;
  int _hadithInterval = 15;

  static const _supportedLanguages = {
    'ar': 'العربية',
    'bn': 'বাংলা',
    'en': 'English',
    'es': 'Español',
    'id': 'Bahasa Indonesia',
    'fil': 'Filipino',
    'so': 'Soomaali',
    'ur': 'اردو',
    'tr': 'Türkçe',
  };

  static const _prayerKeys = [
    'fajr',
    'sunrise',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];
  static Map<String, String> get _prayerLabels => {
    'fajr': AppStrings.fajr,
    'sunrise': AppStrings.sunrise,
    'dhuhr': AppStrings.dhuhr,
    'asr': AppStrings.asr,
    'maghrib': AppStrings.maghrib,
    'isha': AppStrings.isha,
  };

  @override
  void initState() {
    super.initState();
    final device = ctrl.selectedDevice.value;
    _selectedDisplayMode = DisplayMode.values.firstWhere(
      (m) => m.value == (device?.displayMode ?? 'prayer_times'),
      orElse: () => DisplayMode.prayerTimes,
    );
    _selectedMethod =
        CalculationMethodType.values.firstWhereOrNull(
          (m) => m.value == (device?.settings?.calculationMethod),
        ) ??
        CalculationMethodType.ummAlQura;
    _selectedMadhab = device?.settings?.madhab ?? 0;
    _latitude = device?.settings?.latitude ?? 0;
    _longitude = device?.settings?.longitude ?? 0;
    _city = device?.settings?.city ?? '';
    _country = device?.settings?.country ?? '';
    _adjustments = Map<String, int>.from(device?.settings?.adjustments ?? {});
    _selectedLanguage = device?.settings?.language ?? 'ar';
    _isDarkMode = device?.settings?.isDarkMode ?? false;
    _hadithInterval = device?.settings?.hadithInterval ?? 15;
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  void _showRenameDialog(BuildContext context) {
    final currentName = ctrl.selectedDevice.value?.name ?? '';
    final textController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text(AppStrings.renameDevice),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(labelText: AppStrings.deviceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              final newName = textController.text.trim();
              if (newName.isNotEmpty) {
                ctrl.updateDeviceName(newName);
              }
              Navigator.pop(ctx);
            },
            child: Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  Future<void> _detectLocation() async {
    setState(() => _detectingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.locationPermissionRequired,
                style: AppTextStyles.bodyMedium().copyWith(
                  color: AppColors.whiteCream,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        if (placemarks.isNotEmpty) {
          _city = placemarks.first.locality ?? '';
          _country = placemarks.first.country ?? '';
        }
      });
      _markChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppStrings.locationError}: $e',
              style: AppTextStyles.bodyMedium().copyWith(
                color: AppColors.whiteCream,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _detectingLocation = false);
    }
  }

  Future<void> _save() async {
    final device = ctrl.selectedDevice.value;
    if (device == null) return;

    // Save display mode
    await ctrl.updateDeviceDisplayMode(_selectedDisplayMode);

    // Save settings (always include location)
    final updated = DeviceSettingsEntity(
      id: device.settings?.id,
      deviceId: device.id,
      latitude: _latitude,
      longitude: _longitude,
      city: _city,
      country: _country,
      calculationMethod: _selectedMethod.value,
      madhab: _selectedMadhab,
      highLatitudeRule: device.settings?.highLatitudeRule ?? 0,
      adjustments: _adjustments,
      language: _selectedLanguage,
      isDarkMode: _isDarkMode,
      hadithInterval: _hadithInterval,
    );
    await ctrl.updateDeviceSettings(updated);

    // Apply locale locally
    Get.updateLocale(Locale(_selectedLanguage));
    await GetStorage().write('LOCALE', _selectedLanguage);

    setState(() => _hasChanges = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.savedSuccessfully,
            style: AppTextStyles.bodyMedium().copyWith(
              color: AppColors.whiteCream,
            ),
          ),
          backgroundColor: AppColors.tealGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: AppColors.whiteCream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => GestureDetector(
            onTap: () => _showRenameDialog(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    ctrl.selectedDevice.value?.name ?? AppStrings.settings,
                    style: AppTextStyles.titleMedium().copyWith(
                      color: AppColors.whiteCream,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.edit, size: 16, color: AppColors.whiteCream),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        final device = ctrl.selectedDevice.value;
        if (device == null) {
          return Center(child: Text(AppStrings.noDeviceSelected));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Location section
            _SectionCard(
              title: AppStrings.location,
              children: [
                if (_latitude != 0 || _longitude != 0) ...[
                  _InfoRow(
                    label: AppStrings.city,
                    value: _city.isNotEmpty ? _city : AppStrings.notSet,
                  ),
                  _InfoRow(
                    label: AppStrings.country,
                    value: _country.isNotEmpty ? _country : AppStrings.notSet,
                  ),
                  _InfoRow(
                    label: AppStrings.coordinates,
                    value:
                        '${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                  ),
                  const Gap(8),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      AppStrings.locationNotSet,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _detectingLocation ? null : _detectLocation,
                    icon: _detectingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      _detectingLocation
                          ? AppStrings.detectingLocation
                          : AppStrings.detectLocation,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.tealGreen,
                      side: const BorderSide(color: AppColors.tealGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Calculation method
            _SectionCard(
              title: AppStrings.calculationMethod,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CalculationMethodType.values.map((method) {
                    final isSelected = _selectedMethod == method;
                    return ContainerButton(
                      title: method.localizedName,
                      isSelected: isSelected,
                      isTitleCentered: true,
                      onPressed: () {
                        setState(() => _selectedMethod = method);
                        _markChanged();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const Gap(16),

            // Display mode
            _SectionCard(
              title: AppStrings.displayMode,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: DisplayMode.values.map((mode) {
                    final isSelected = _selectedDisplayMode == mode;
                    return ContainerButton(
                      title: mode.localizedLabel,
                      isSelected: isSelected,
                      isTitleCentered: true,
                      onPressed: () {
                        setState(() => _selectedDisplayMode = mode);
                        _markChanged();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const Gap(16),

            // Hadith interval (shown for hadith or combined mode)
            if (_selectedDisplayMode == DisplayMode.hadith ||
                _selectedDisplayMode == DisplayMode.combined)
              _SectionCard(
                title: AppStrings.hadithDisplayDuration,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.tealGreen,
                        iconSize: 28,
                        onPressed: _hadithInterval > 1
                            ? () {
                                setState(() => _hadithInterval--);
                                _markChanged();
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '$_hadithInterval',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium().copyWith(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.tealGreen,
                        iconSize: 28,
                        onPressed: _hadithInterval < 60
                            ? () {
                                setState(() => _hadithInterval++);
                                _markChanged();
                              }
                            : null,
                      ),
                      const Gap(8),
                      Text(
                        AppStrings.minutes,
                        style: AppTextStyles.bodyMedium().copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (_selectedDisplayMode == DisplayMode.hadith ||
                _selectedDisplayMode == DisplayMode.combined)
              const Gap(16),

            // Madhab
            _SectionCard(
              title: AppStrings.madhab,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ContainerButton(
                        title: AppStrings.shafi,
                        isSelected: _selectedMadhab == 0,
                        isTitleCentered: true,
                        onPressed: () {
                          setState(() => _selectedMadhab = 0);
                          _markChanged();
                        },
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ContainerButton(
                        title: AppStrings.hanafi,
                        isSelected: _selectedMadhab == 1,
                        isTitleCentered: true,
                        onPressed: () {
                          setState(() => _selectedMadhab = 1);
                          _markChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),

            // Language
            _SectionCard(
              title: AppStrings.language,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _supportedLanguages.entries.map((e) {
                    final isSelected = _selectedLanguage == e.key;
                    return ContainerButton(
                      title: e.value,
                      isSelected: isSelected,
                      isTitleCentered: true,
                      onPressed: () {
                        setState(() => _selectedLanguage = e.key);
                        _markChanged();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const Gap(16),

            // Prayer time adjustments
            _SectionCard(
              title: AppStrings.adjustPrayerTimes,
              children: [
                Text(
                  AppStrings.adjustPrayerTimesDesc,
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontSize: 13,
                  ),
                ),
                const Gap(12),
                ..._prayerKeys.map((key) {
                  final value = _adjustments[key] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            _prayerLabels[key]!,
                            style: AppTextStyles.bodySmall().copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.tealGreen,
                          iconSize: 28,
                          onPressed: value > -30
                              ? () {
                                  setState(() => _adjustments[key] = value - 1);
                                  _markChanged();
                                }
                              : null,
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${value >= 0 ? '+' : ''}$value',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium().copyWith(
                              color: value == 0
                                  ? AppColors.darkText
                                  : AppColors.tealGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.tealGreen,
                          iconSize: 28,
                          onPressed: value < 30
                              ? () {
                                  setState(() => _adjustments[key] = value + 1);
                                  _markChanged();
                                }
                              : null,
                        ),
                        const Spacer(),
                        if (value != 0)
                          Text(
                            '$value د',
                            style: AppTextStyles.bodySmall().copyWith(
                              color: AppColors.darkText.withValues(alpha: .5),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const Gap(16),

            // Dark mode
            _SectionCard(
              title: AppStrings.darkMode,
              children: [
                CustomSwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: AppStrings.darkMode,
                  value: _isDarkMode,
                  onChanged: (v) {
                    setState(() => _isDarkMode = v);
                    _markChanged();
                  },
                ),
              ],
            ),
            const Gap(24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _hasChanges ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealGreen,
                  foregroundColor: AppColors.whiteCream,
                  disabledBackgroundColor: AppColors.sand,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.save,
                  style: AppTextStyles.titleMedium().copyWith(
                    color: _hasChanges
                        ? AppColors.whiteCream
                        : AppColors.darkText.withValues(alpha: .4),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.whiteCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium().copyWith(
                color: AppColors.tealGreen,
              ),
            ),
            const Gap(12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium()),
          Text(
            value,
            style: AppTextStyles.bodyMedium().copyWith(
              color: AppColors.primaryDarkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
