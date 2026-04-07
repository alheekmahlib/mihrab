import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../../app/routes.dart';
import '../../controllers/auto_rotate_controller.dart';
import '../../controllers/device_controller.dart';
import '../../controllers/prayer_controller.dart';
import '../combined/combined_screen.dart';
import '../hadith/hadith_screen.dart';
import '../prayer_qibla/prayer_qibla_screen.dart';
import '../prayer_times/prayer_times_screen.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final _deviceCtrl = Get.find<DeviceController>();
  final _prayerCtrl = Get.find<PrayerController>();
  final _showOverlay = false.obs;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    _initializePrayers();
    // Re-initialize when settings change (e.g. after pairing completes)
    ever(_deviceCtrl.settings, (settings) {
      if (settings != null &&
          settings.latitude != null &&
          settings.longitude != null &&
          (settings.latitude != 0 || settings.longitude != 0)) {
        _initializePrayers();
      }
    });
  }

  Future<void> _initializePrayers() async {
    final settings = _deviceCtrl.settings.value;
    if (settings?.latitude != null &&
        settings?.longitude != null &&
        (settings!.latitude != 0 || settings.longitude != 0)) {
      await _prayerCtrl.initialize(
        lat: settings.latitude!,
        lng: settings.longitude!,
        method: CalculationMethodType.values.firstWhere(
          (e) => e.value == settings.calculationMethod,
          orElse: () => CalculationMethodType.ummAlQura,
        ),
        madhabValue: settings.madhab ?? 0,
        highLat: settings.highLatitudeRule ?? 0,
        adj: settings.adjustments,
      );
    }
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    super.dispose();
  }

  void _showControls() {
    _overlayTimer?.cancel();
    _showOverlay.value = true;
    _overlayTimer = Timer(const Duration(seconds: 15), () {
      _showOverlay.value = false;
    });
  }

  void _hideControls() {
    _overlayTimer?.cancel();
    _showOverlay.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            // Menu key opens settings
            if (event.logicalKey == LogicalKeyboardKey.contextMenu ||
                event.logicalKey == LogicalKeyboardKey.f1) {
              Get.toNamed(AppRoutes.settings);
              return KeyEventResult.handled;
            }
            // Any D-pad press shows overlay
            if (!_showOverlay.value) {
              _showControls();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!_showOverlay.value) {
                _showControls();
              }
            },
            child: Stack(
              children: [
                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Obx(() {
                    // Check for prayer alert
                    if (_prayerCtrl.showPrayerAlert.value) {
                      return _PrayerAlertOverlay(
                        prayerName: _prayerCtrl.alertPrayerName.value,
                        onDismiss: _prayerCtrl.dismissAlert,
                      );
                    }

                    final mode = _deviceCtrl.displayMode.value;

                    // Handle auto-rotate mode
                    if (mode == DisplayMode.autoRotate) {
                      if (!Get.isRegistered<AutoRotateController>()) {
                        Get.put(AutoRotateController());
                      }
                      final autoCtrl = Get.find<AutoRotateController>();
                      return Obx(
                        () => _buildScreenForMode(autoCtrl.currentMode.value),
                      );
                    }

                    return _buildScreenForMode(mode);
                  }),
                ),
                // Settings overlay
                Obx(() {
                  if (!_showOverlay.value) return const SizedBox.shrink();
                  return _ControlsOverlay(
                    onSettings: () => Get.toNamed(AppRoutes.settings),
                    onDismiss: _hideControls,
                  );
                }),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(
                    'assets/images/decorations.svg',
                    width: 90,
                    height: 90,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SvgPicture.asset(
                      'assets/images/decorations.svg',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset(
                      'assets/images/decorations.svg',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: SvgPicture.asset(
                      'assets/images/decorations.svg',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenForMode(DisplayMode mode) {
    switch (mode) {
      case DisplayMode.prayerTimes:
        return const PrayerTimesScreen();
      case DisplayMode.hadith:
        return const HadithScreen();
      case DisplayMode.combined:
        return const CombinedScreen();
      case DisplayMode.prayerQibla:
        return const PrayerQiblaScreen();
      case DisplayMode.autoRotate:
        return const PrayerTimesScreen();
    }
  }
}

class _PrayerAlertOverlay extends StatelessWidget {
  final String prayerName;
  final VoidCallback onDismiss;

  const _PrayerAlertOverlay({
    required this.prayerName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      autofocus: true,
      onSelect: onDismiss,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDarkGreen.withValues(alpha: .95),
              AppColors.mediumGreen.withValues(alpha: .95),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mosque_rounded,
              size: 100,
              color: AppColors.whiteCream,
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.prayerTimeArrived,
              style: AppTextStyles.tvTitle().copyWith(
                color: AppColors.whiteCream,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              prayerName,
              style: AppTextStyles.tvCountdown().copyWith(
                color: AppColors.whiteCream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  final VoidCallback onSettings;
  final VoidCallback onDismiss;

  const _ControlsOverlay({required this.onSettings, required this.onDismiss});

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  final _settingsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _settingsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _settingsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: .6),
        child: Center(
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.escape ||
                      event.logicalKey == LogicalKeyboardKey.goBack)) {
                widget.onDismiss();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TvFocusable(
                    focusNode: _settingsFocusNode,
                    onSelect: widget.onSettings,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.settings, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.settings,
                          style: AppTextStyles.tvBody().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  TvFocusable(
                    onSelect: widget.onDismiss,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.close, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.close,
                          style: AppTextStyles.tvBody().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
