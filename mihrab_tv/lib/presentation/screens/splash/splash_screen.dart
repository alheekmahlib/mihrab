import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../../app/routes.dart';
import '../../controllers/device_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  void _navigate() {
    final deviceCtrl = Get.find<DeviceController>();
    final settings = deviceCtrl.settings.value;
    final hasValidLocation =
        settings?.latitude != null &&
        settings?.longitude != null &&
        (settings!.latitude != 0 || settings.longitude != 0);
    if (deviceCtrl.isSetupComplete.value && hasValidLocation) {
      Get.offAllNamed(AppRoutes.display);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scale = (size.shortestSide / 800).clamp(0.5, 1.5);
    final logoSize = (160 * scale).clamp(80.0, 200.0);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/mihrab_logo.svg',
                width: logoSize,
                height: logoSize,
              ),
              SizedBox(height: 24 * scale),
              Text(
                AppStrings.appDescription,
                style: AppTextStyles.tvBody(
                  fontSize: (22 * scale).clamp(16, 28),
                ).copyWith(color: context.theme.colorScheme.inversePrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
