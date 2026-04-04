import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/prayer_controller.dart';

class PrayerQiblaScreen extends StatelessWidget {
  const PrayerQiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerCtrl = Get.find<PrayerController>();
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(24 * scale),
      child: isPortrait
          ? Column(
              children: [
                Expanded(
                  flex: 5,
                  child: _PrayerPanel(ctrl: prayerCtrl, scale: scale),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Divider(color: AppColors.sand.withValues(alpha: .4)),
                ),
                Expanded(
                  flex: 4,
                  child: _QiblaPanel(ctrl: prayerCtrl, scale: scale),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 4,
                        child: _PrayerPanel(ctrl: prayerCtrl, scale: scale),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Gap(16 * scale),
                Container(
                  width: 2,
                  margin: EdgeInsets.symmetric(vertical: 24 * scale),
                  color: AppColors.sand.withValues(alpha: .4),
                ),
                Gap(16 * scale),
                Expanded(
                  flex: 4,
                  child: _QiblaPanel(ctrl: prayerCtrl, scale: scale),
                ),
              ],
            ),
    );
  }
}

class _PrayerPanel extends StatelessWidget {
  final PrayerController ctrl;
  final double scale;
  const _PrayerPanel({required this.ctrl, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pt = ctrl.prayerTimes.value;
      if (pt == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.tealGreen),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ctrl.currentDateHijri.value,
            style: AppTextStyles.titleMedium(
              fontSize: (18 * scale).clamp(14, 22),
            ).copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            ctrl.currentDateGregorian.value,
            style:
                AppTextStyles.bodyMedium(
                  fontSize: (16 * scale).clamp(12, 20),
                ).copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .7),
                ),
          ),
          Gap(12 * scale),
          Text(
            '${AppStrings.nextPrayer}: ${pt.nextPrayer.localizedName}',
            style: AppTextStyles.tvBody(
              fontSize: (22 * scale).clamp(16, 28),
            ).copyWith(color: Theme.of(context).colorScheme.tertiary),
          ),
          Gap(6 * scale),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              ctrl.countdownText.value,
              style: AppTextStyles.tvTitle(fontSize: (36 * scale).clamp(24, 42))
                  .copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
            ),
          ),
          Gap(16 * scale),
          Flexible(
            child: _CompactPrayerList(pt: pt, scale: scale),
          ),
        ],
      );
    });
  }
}

class _CompactPrayerList extends StatelessWidget {
  final PrayerTimeEntity pt;
  final double scale;
  const _CompactPrayerList({required this.pt, required this.scale});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      (PrayerType.fajr, pt.fajr),
      (PrayerType.sunrise, pt.sunrise),
      (PrayerType.dhuhr, pt.dhuhr),
      (PrayerType.asr, pt.asr),
      (PrayerType.maghrib, pt.maghrib),
      (PrayerType.isha, pt.isha),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: prayers.map((entry) {
        final (prayer, time) = entry;
        final isNext = prayer == pt.nextPrayer;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 6 * scale,
          ),
          margin: EdgeInsets.only(bottom: 3 * scale),
          decoration: BoxDecoration(
            color: isNext
                ? Theme.of(context).colorScheme.surface.withValues(alpha: .12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prayer.localizedName,
                style:
                    AppTextStyles.titleMedium(
                      fontSize: (22 * scale).clamp(16, 28),
                    ).copyWith(
                      color: isNext
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    ),
              ),
              Text(
                DateFormat('hh:mm a', 'ar').format(time),
                style:
                    AppTextStyles.titleMedium(
                      fontSize: (22 * scale).clamp(16, 28),
                    ).copyWith(
                      color: isNext
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isNext ? FontWeight.bold : FontWeight.w400,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QiblaPanel extends StatelessWidget {
  final PrayerController ctrl;
  final double scale;
  const _QiblaPanel({required this.ctrl, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.explore_rounded,
              size: (64 * scale).clamp(40, 80),
              color: AppColors.tealGreen,
            ),
            Gap(16 * scale),
            Text(
              AppStrings.qiblaDirection,
              style: AppTextStyles.tvTitle(
                fontSize: (30 * scale).clamp(20, 36),
              ).copyWith(color: AppColors.tealGreen),
            ),
            Gap(20 * scale),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${ctrl.qiblaDirection.value.toStringAsFixed(1)}°',
                style: AppTextStyles.tvCountdown(
                  fontSize: (60 * scale).clamp(36, 72),
                ).copyWith(color: context.theme.colorScheme.inversePrimary),
              ),
            ),
            Gap(12 * scale),
            Text(
              ctrl.qiblaCardinalDirection,
              style: AppTextStyles.tvTitle(
                fontSize: (28 * scale).clamp(18, 36),
              ).copyWith(color: context.theme.colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
