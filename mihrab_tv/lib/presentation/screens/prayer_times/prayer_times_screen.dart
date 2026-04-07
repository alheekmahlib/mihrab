import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/prayer_controller.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PrayerController>();
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 56, vertical: 36 * scale),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/mihrab_logo.svg',
            height: double.infinity,
            colorFilter: ColorFilter.mode(
              Theme.of(
                context,
              ).colorScheme.inversePrimary.withValues(alpha: .02),
              BlendMode.srcIn,
            ),
          ),
          isPortrait
              ? _buildPortraitLayout(ctrl, scale)
              : _buildLandscapeLayout(ctrl, scale),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(PrayerController ctrl, double scale) {
    return Column(
      children: [
        _DateRow(ctrl: ctrl, scale: scale),
        Gap(16 * scale),
        Expanded(
          flex: 3,
          child: _CountdownSection(ctrl: ctrl, scale: scale),
        ),
        Gap(12 * scale),
        _PrayerTimesGrid(ctrl: ctrl, scale: scale, isPortrait: false),
      ],
    );
  }

  Widget _buildPortraitLayout(PrayerController ctrl, double scale) {
    return Column(
      children: [
        _DateRow(ctrl: ctrl, scale: scale),
        Spacer(),
        _CountdownSection(ctrl: ctrl, scale: scale),
        Spacer(),
        _PrayerTimesGrid(ctrl: ctrl, scale: scale, isPortrait: true),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final PrayerController ctrl;
  final double scale;
  const _DateRow({required this.ctrl, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              ctrl.currentDateHijri.value,
              style: AppTextStyles.tvTitle(
                fontSize: (28 * scale).clamp(18, 36),
              ).copyWith(color: Theme.of(context).colorScheme.inversePrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(16 * scale),
          Flexible(
            child: Text(
              ctrl.currentDateGregorian.value,
              style: AppTextStyles.tvTitle(
                fontSize: (28 * scale).clamp(18, 36),
              ).copyWith(color: Theme.of(context).colorScheme.inversePrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownSection extends StatelessWidget {
  final PrayerController ctrl;
  final double scale;
  const _CountdownSection({required this.ctrl, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final pt = ctrl.prayerTimes.value;
        if (pt == null) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.tertiary,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.nextPrayer,
              style: AppTextStyles.tvTitle(
                fontSize: (30 * scale).clamp(20, 36),
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            Text(
              pt.nextPrayer.localizedName,
              style: AppTextStyles.tvTitle(
                fontSize: (40 * scale).clamp(30, 46),
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            Gap(12 * scale),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 36 * scale,
                vertical: 14 * scale,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ctrl.countdownText.value,
                style:
                    AppTextStyles.tvCountdown(
                      fontSize: (60 * scale).clamp(32, 72),
                    ).copyWith(
                      height: 1.1,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PrayerTimesGrid extends StatelessWidget {
  final PrayerController ctrl;
  final double scale;
  final bool isPortrait;
  const _PrayerTimesGrid({
    required this.ctrl,
    required this.scale,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pt = ctrl.prayerTimes.value;
      if (pt == null) return const SizedBox.shrink();

      final prayers = [
        (PrayerType.fajr, pt.fajr),
        (PrayerType.sunrise, pt.sunrise),
        (PrayerType.dhuhr, pt.dhuhr),
        (PrayerType.asr, pt.asr),
        (PrayerType.maghrib, pt.maghrib),
        (PrayerType.isha, pt.isha),
      ];

      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 6 * scale,
          horizontal: 16 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.mediumGreen.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: isPortrait
            ? _buildPortraitGrid(context, prayers, pt)
            : _buildLandscapeGrid(prayers, pt),
      );
    });
  }

  Widget _buildLandscapeGrid(
    List<(PrayerType, DateTime)> prayers,
    PrayerTimeEntity pt,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: prayers.map((entry) {
        final (prayer, time) = entry;
        return Expanded(
          child: _PrayerTimeCard(
            name: prayer.localizedName,
            time: DateFormat('hh:mm').format(time),
            period: DateFormat('a', 'ar').format(time),
            isHighlighted: prayer == pt.nextPrayer,
            isCurrent: prayer == pt.currentPrayer,
            scale: scale,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPortraitGrid(
    BuildContext context,
    List<(PrayerType, DateTime)> prayers,
    PrayerTimeEntity pt,
  ) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.32,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 12 * scale),
        children: prayers.map((entry) {
          final (prayer, time) = entry;
          final isNext = prayer == pt.nextPrayer;
          final isCurrent = prayer == pt.currentPrayer;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 10 * scale,
            ),
            margin: EdgeInsets.only(bottom: 4 * scale),
            decoration: BoxDecoration(
              color: isNext
                  ? Theme.of(context).colorScheme.surface.withValues(alpha: .15)
                  : isCurrent
                  ? Theme.of(
                      context,
                    ).colorScheme.tertiary.withValues(alpha: .08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prayer.localizedName,
                  style:
                      AppTextStyles.tvBody(
                        fontSize: (24 * scale).clamp(18, 30),
                      ).copyWith(
                        color: isNext
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                      ),
                ),
                Text(
                  '${DateFormat('hh:mm').format(time)} ${DateFormat('a', 'ar').format(time)}',
                  style:
                      AppTextStyles.tvBody(
                        fontSize: (24 * scale).clamp(18, 30),
                      ).copyWith(
                        color: isNext
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: isNext ? FontWeight.bold : FontWeight.w400,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;
  final String period;
  final bool isHighlighted;
  final bool isCurrent;
  final double scale;

  const _PrayerTimeCard({
    required this.name,
    required this.time,
    required this.period,
    required this.scale,
    this.isHighlighted = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 8 * scale,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4 * scale),
      decoration: BoxDecoration(
        color: isHighlighted
            ? Theme.of(context).colorScheme.surface.withValues(alpha: .15)
            : isCurrent
            ? Theme.of(context).colorScheme.tertiary.withValues(alpha: .08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: AppTextStyles.tvBody(fontSize: (22 * scale).clamp(14, 28))
                  .copyWith(
                    color: isHighlighted
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: isHighlighted
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
            ),
            Gap(4 * scale),
            Text(
              '$time $period',
              style: AppTextStyles.tvTitle(fontSize: (28 * scale).clamp(18, 36))
                  .copyWith(
                    color: isHighlighted
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
