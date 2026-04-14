import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/hadith_controller.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  static const _fontSizeMultipliers = {1: 0.7, 2: 0.85, 3: 1.0, 4: 1.2, 5: 1.4};

  static Widget _fadeSlideTransition(Widget child, Animation<double> anim) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HadithController>();
    final deviceCtrl = Get.find<DeviceController>();
    final size = MediaQuery.sizeOf(context);
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 56, vertical: 36 * scale),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Obx(() {
        final hadith = ctrl.currentHadith.value;

        if (hadith == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.tealGreen),
          );
        }

        return Column(
          children: [
            // Header: collection name + hadith number
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 2000),
              transitionBuilder: _fadeSlideTransition,
              child: Row(
                key: ValueKey('header_${hadith.arabicURN}'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _collectionArabicName(hadith.collection),
                      style: AppTextStyles.tvTitle(
                        fontSize: (30 * scale).clamp(20, 36),
                      ).copyWith(color: AppColors.tealGreen),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${AppStrings.hadithNumber} ${hadith.hadithNumber}',
                    style:
                        AppTextStyles.tvBody(
                          fontSize: (22 * scale).clamp(14, 28),
                        ).copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.inversePrimary.withValues(alpha: .6),
                        ),
                  ),
                ],
              ),
            ),
            // Book name
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 2000),
              transitionBuilder: _fadeSlideTransition,
              child: hadith.bookName.isNotEmpty
                  ? Padding(
                      key: ValueKey('book_${hadith.arabicURN}'),
                      padding: EdgeInsets.only(top: 6 * scale),
                      child: Text(
                        hadith.bookName,
                        style:
                            AppTextStyles.titleMedium(
                              fontSize: (18 * scale).clamp(16, 24),
                            ).copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    )
                  : SizedBox.shrink(
                      key: ValueKey('nobook_${hadith.arabicURN}'),
                    ),
            ),
            Gap(16 * scale),
            Divider(color: AppColors.sand.withValues(alpha: .5), thickness: 1),
            Gap(16 * scale),
            // Hadith text
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: _fadeSlideTransition,
                child: Center(
                  key: ValueKey('text_${hadith.arabicURN}'),
                  child: SingleChildScrollView(
                    child: Obx(() {
                      final fontLevel =
                          deviceCtrl.settings.value?.hadithFontSize ?? 3;
                      final fontMultiplier =
                          _fontSizeMultipliers[fontLevel] ?? 1.0;
                      return Text(
                        hadith.hadithText,
                        style:
                            AppTextStyles.tvHadith(
                              fontSize: (28 * scale * fontMultiplier).clamp(
                                14,
                                48,
                              ),
                            ).copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                              height: 2.2,
                            ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      );
                    }),
                  ),
                ),
              ),
            ),
            Gap(12 * scale),
            Divider(color: AppColors.sand.withValues(alpha: .5), thickness: 1),
            Gap(6 * scale),
            // Grade + bab name
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 2000),
              transitionBuilder: _fadeSlideTransition,
              child: Row(
                key: ValueKey('footer_${hadith.arabicURN}'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (hadith.grade != null && hadith.grade!.isNotEmpty)
                    Text(
                      hadith.grade!,
                      style: AppTextStyles.bodyMedium(
                        fontSize: (16 * scale).clamp(16, 22),
                      ).copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
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
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _collectionArabicName(HadithCollection collection) {
    return collection.localizedName;
  }
}
