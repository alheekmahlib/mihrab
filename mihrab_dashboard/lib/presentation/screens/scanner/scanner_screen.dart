import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/routes.dart';
import '../../controllers/dashboard_controller.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _scannerController = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: AppColors.whiteCream,
        title: Text(
          AppStrings.scanQrCode,
          style: AppTextStyles.titleMedium().copyWith(
            color: AppColors.whiteCream,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: _onDetect,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppStrings.scannerInstructions,
              style: AppTextStyles.bodyLarge().copyWith(
                color: AppColors.whiteCream,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_hasScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    _hasScanned = true;
    _scannerController.stop();

    // QR format: mihrab://pair?token=UUID
    final rawValue = barcode.rawValue!;
    final uri = Uri.tryParse(rawValue);
    final token = uri?.queryParameters['token'] ?? rawValue;

    final ctrl = Get.find<DashboardController>();
    final success = await ctrl.pairDevice(token);

    if (success) {
      Get.offNamed(AppRoutes.deviceSettings);
    } else {
      Get.snackbar(
        'خطأ',
        ctrl.errorMessage.value,
        backgroundColor: Colors.red,
        colorText: AppColors.warmCream,
      );
      _hasScanned = false;
      _scannerController.start();
    }
  }
}
