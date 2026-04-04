import 'dart:async';

import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../domain/repositories/hadith_repository.dart';

class HadithController extends GetxController {
  final HadithRepository _repository;

  HadithController(this._repository);

  final currentHadith = Rxn<HadithEntity>();
  final isLoading = true.obs;
  final rotationInterval = 15.obs; // minutes

  Timer? _rotationTimer;
  HadithEntity? _previousHadith;

  @override
  void onInit() {
    super.onInit();
    loadNextHadith();
    _startRotation();
  }

  @override
  void onClose() {
    _rotationTimer?.cancel();
    super.onClose();
  }

  Future<void> loadNextHadith() async {
    isLoading.value = true;
    try {
      HadithEntity hadith;
      // Avoid showing the same hadith twice in a row
      int attempts = 0;
      do {
        hadith = await _repository.getRandomHadith();
        attempts++;
      } while (_previousHadith != null &&
          hadith.arabicURN == _previousHadith!.arabicURN &&
          attempts < 3);

      _previousHadith = hadith;
      currentHadith.value = hadith;
    } catch (_) {
      // Keep showing current hadith if loading fails
    } finally {
      isLoading.value = false;
    }
  }

  void _startRotation() {
    _rotationTimer?.cancel();
    _rotationTimer = Timer.periodic(
      Duration(minutes: rotationInterval.value),
      (_) => loadNextHadith(),
    );
  }

  void updateRotationInterval(int minutes) {
    rotationInterval.value = minutes;
    _startRotation();
  }

  /// Pause rotation (e.g., during prayer alert)
  void pauseRotation() {
    _rotationTimer?.cancel();
  }

  /// Resume rotation after pause
  void resumeRotation() {
    _startRotation();
  }
}
