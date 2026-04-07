import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../controllers/hadith_controller.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HadithController>();
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

        if (hadith == null || ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.tealGreen),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Column(
            key: ValueKey(hadith.arabicURN),
            children: [
              // Header: collection name + hadith number
              Row(
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
              if (hadith.bookName.isNotEmpty) ...[
                Gap(6 * scale),
                Text(
                  hadith.bookName,
                  style:
                      AppTextStyles.titleMedium(
                        fontSize: (18 * scale).clamp(16, 24),
                      ).copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
              Gap(16 * scale),
              Divider(
                color: AppColors.sand.withValues(alpha: .5),
                thickness: 1,
              ),
              Gap(16 * scale),
              // Hadith text
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      hadith.hadithText,
                      style:
                          AppTextStyles.tvHadith(
                            fontSize: (28 * scale).clamp(18, 32),
                          ).copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            height: 2.2,
                          ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              Gap(12 * scale),
              Divider(
                color: AppColors.sand.withValues(alpha: .5),
                thickness: 1,
              ),
              Gap(6 * scale),
              // Grade + bab name
              Row(
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
            ],
          ),
        );
      }),
    );
  }

  String _collectionArabicName(HadithCollection collection) {
    return collection.localizedName;
  }
}
