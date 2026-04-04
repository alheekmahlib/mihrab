import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:web/web.dart' as web;

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteCream,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            child: Column(
              children: [
                _HeroSection(isWide: isWide),
                _FeaturesSection(isWide: isWide),
                const _Footer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isWide;
  const _HeroSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 80 : 48,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDarkGreen, AppColors.mediumGreen],
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/mihrab_logo.svg',
            height: isWide ? 100 : 72,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteCream,
              BlendMode.srcIn,
            ),
          ),
          const Gap(24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'appDescriptionLong'.tr,
              style: AppTextStyles.titleMedium(fontSize: isWide ? 22 : 18)
                  .copyWith(
                    color: AppColors.whiteCream.withValues(alpha: .9),
                    height: 1.6,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(36),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final base = Uri.base.resolve('tv/').toString();
                  web.window.open(base, '_blank');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldAmber,
                  foregroundColor: AppColors.whiteCream,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.tv_rounded),
                label: Text(
                  'openDisplay'.tr,
                  style: AppTextStyles.titleMedium(
                    fontSize: 18,
                    color: AppColors.whiteCream,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'or'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 24,
              color: AppColors.whiteCream,
            ),
          ),
          const Gap(16),
          _DownloadSection(isWide: isWide),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  final bool isWide;
  const _FeaturesSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureData(
        icon: Icons.access_time_rounded,
        title: 'featurePrayerTimes'.tr,
        description: 'featurePrayerTimesDesc'.tr,
      ),
      _FeatureData(
        icon: Icons.menu_book_rounded,
        title: 'featureHadith'.tr,
        description: 'featureHadithDesc'.tr,
      ),
      _FeatureData(
        icon: Icons.explore_rounded,
        title: 'featureQibla'.tr,
        description: 'featureQiblaDesc'.tr,
      ),
      _FeatureData(
        icon: Icons.tv_rounded,
        title: 'featureMultiScreen'.tr,
        description: 'featureMultiScreenDesc'.tr,
      ),
      _FeatureData(
        icon: Icons.language_rounded,
        title: 'featureMultiLanguage'.tr,
        description: 'featureMultiLanguageDesc'.tr,
      ),
      _FeatureData(
        icon: Icons.fullscreen_rounded,
        title: 'featureFullscreen'.tr,
        description: 'featureFullscreenDesc'.tr,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 60),
      child: Column(
        children: [
          Text(
            'features'.tr,
            style: AppTextStyles.tvTitle(
              fontSize: isWide ? 36 : 28,
              color: AppColors.primaryDarkGreen,
            ),
          ),
          const Gap(40),
          isWide
              ? Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: features
                      .map(
                        (f) => SizedBox(
                          width: 320,
                          child: _FeatureCard(feature: f),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  children: features
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _FeatureCard(feature: f),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.whiteCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tealGreen.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(feature.icon, size: 36, color: AppColors.tealGreen),
            ),
            const Gap(16),
            Text(
              feature.title,
              style: AppTextStyles.titleMedium(
                color: AppColors.primaryDarkGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              feature.description,
              style: AppTextStyles.bodySmall().copyWith(
                color: AppColors.darkText.withValues(alpha: .7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadSection extends StatelessWidget {
  final bool isWide;
  const _DownloadSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'downloadApps'.tr,
          style: AppTextStyles.tvTitle(
            fontSize: isWide ? 32 : 24,
            color: AppColors.warmCream,
          ),
        ),
        const Gap(24),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _DownloadButton(
              label: 'downloadTvApp'.tr,
              icon: Icons.tv_rounded,
              onPressed: () {},
            ),
            _DownloadButton(
              label: 'downloadDashboard'.tr,
              icon: Icons.phone_android_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _DownloadButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.warmCream,
        side: const BorderSide(color: AppColors.warmCream, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: AppTextStyles.titleSmall(color: AppColors.warmCream),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: AppColors.primaryDarkGreen,
      child: Text(
        '© مكتبة الحكمة 1447 هـ',
        style: AppTextStyles.bodySmall(
          fontSize: 14,
        ).copyWith(color: AppColors.whiteCream.withValues(alpha: .7)),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
