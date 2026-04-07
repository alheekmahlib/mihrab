import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/hadith_controller.dart';
import '../../controllers/prayer_controller.dart';

class CombinedScreen extends StatelessWidget {
  const CombinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerCtrl = Get.find<PrayerController>();
    final hadithCtrl = Get.find<HadithController>();
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 56, vertical: 24 * scale),
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
                  flex: 5,
                  child: _HadithPanel(ctrl: hadithCtrl, scale: scale),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  flex: 5,
                  child: _HadithPanel(ctrl: hadithCtrl, scale: scale),
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

class _HadithPanel extends StatelessWidget {
  final HadithController ctrl;
  final double scale;
  const _HadithPanel({required this.ctrl, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hadith = ctrl.currentHadith.value;
      if (hadith == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.tealGreen),
        );
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        layoutBuilder: (currentChild, previousChildren) {
          return SizedBox.expand(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ...previousChildren,
                ?currentChild,
              ],
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          key: ValueKey(hadith.arabicURN),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _collectionArabicName(hadith.collection),
              style: AppTextStyles.tvBody(
                fontSize: (22 * scale).clamp(16, 28),
              ).copyWith(color: context.theme.colorScheme.tertiary),
            ),
            Gap(6 * scale),
            if (hadith.babName != null && hadith.babName!.isNotEmpty)
              Flexible(
                child: Text(
                  hadith.babName!,
                  style:
                      AppTextStyles.bodySmall(
                        fontSize: (16 * scale).clamp(14, 22),
                      ).copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: .7),
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Gap(12 * scale),
            Divider(color: AppColors.sand.withValues(alpha: .4)),
            Gap(12 * scale),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hadith.hadithText,
                      style:
                          AppTextStyles.tvBody(
                            fontSize: (22 * scale).clamp(16, 28),
                          ).copyWith(
                            color: context.theme.colorScheme.inversePrimary,
                            height: 2.0,
                          ),
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                    ),
                    if (hadith.grade != null && hadith.grade!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 6 * scale),
                        child: Text(
                          hadith.grade!,
                          style: AppTextStyles.bodySmall(
                            fontSize: (18 * scale).clamp(18, 24),
                          ).copyWith(
                            color: context.theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    Gap(8 * scale),
                    Text(
                      '${AppStrings.hadithNumber} ${hadith.hadithNumber}',
                      style:
                          AppTextStyles.bodySmall(
                            fontSize: (14 * scale).clamp(10, 18),
                          ).copyWith(
                            color: context
                                .theme
                                .colorScheme
                                .inversePrimary
                                .withValues(alpha: .5),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _collectionArabicName(HadithCollection collection) {
    return collection.localizedName;
  }
}
