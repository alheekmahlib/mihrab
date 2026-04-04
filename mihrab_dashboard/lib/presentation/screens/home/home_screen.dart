import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../../app/routes.dart';
import '../../controllers/dashboard_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkGreen,
        title: SvgPicture.asset(
          'assets/images/mihrab_logo.svg',
          height: 28,
          colorFilter: const ColorFilter.mode(
            AppColors.whiteCream,
            BlendMode.srcIn,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.tealGreen),
          );
        }

        if (ctrl.devices.isEmpty) {
          return _EmptyState();
        }

        return _DeviceList(ctrl: ctrl);
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.tealGreen,
        foregroundColor: AppColors.whiteCream,
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: Text(AppStrings.pairWithPhone),
        onPressed: () => Get.toNamed(AppRoutes.scanner),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tv_rounded,
              size: 80,
              color: AppColors.tealGreen.withValues(alpha: .4),
            ),
            const Gap(16),
            Text(
              AppStrings.noPairedDevices,
              style: AppTextStyles.titleLarge().copyWith(
                color: AppColors.darkText,
              ),
            ),
            const Gap(8),
            Text(
              AppStrings.scanQrToPair,
              style: AppTextStyles.bodyMedium().copyWith(
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  final DashboardController ctrl;
  const _DeviceList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ctrl.devices.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        final device = ctrl.devices[index];
        return Card(
          elevation: 2,
          color: AppColors.whiteCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const Icon(
              Icons.tv_rounded,
              color: AppColors.tealGreen,
              size: 36,
            ),
            title: Text(
              device.name ?? '${AppStrings.screenLabel} ${index + 1}',
              style: AppTextStyles.titleMedium().copyWith(
                color: AppColors.primaryDarkGreen,
              ),
            ),
            subtitle: Text(
              device.settings?.city ?? AppStrings.notSet,
              style: AppTextStyles.bodySmall(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _confirmDelete(context, ctrl, device),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.goldAmber,
                  size: 20,
                ),
              ],
            ),
            onTap: () {
              ctrl.selectDevice(device);
              Get.toNamed(AppRoutes.deviceSettings);
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    DashboardController ctrl,
    DeviceEntity device,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text(AppStrings.deleteDevice),
        content: Text(AppStrings.deleteDeviceConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ctrl.removeDevice(device.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
