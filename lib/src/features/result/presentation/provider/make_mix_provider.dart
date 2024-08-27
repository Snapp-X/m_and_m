import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/domain/repository/dbus_repository.dart';

final makeMixNotifierProvider =
    StateNotifierProvider.autoDispose<MakeMixNotifier, AsyncValue?>(
  (ref) => MakeMixNotifier(dBusRepository: ref.read(dBusRepositoryProvider)),
);

class MakeMixNotifier extends StateNotifier<AsyncValue?> {
  MakeMixNotifier({required this.dBusRepository}) : super(null);

  final DBusRepository dBusRepository;

  Future<void> startMixing(CandyBox candyBox) async {
    try {
      state = const AsyncValue.loading();

      for (var candy in candyBox.portions.values) {
        log('Throttling motor for candy $candy');
        final result = await dBusRepository.throttleMotor(candy.index);

        if (!result) {
          throw Exception('Failed to start motor $candy');
        }
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = AsyncValue.error(e, s);
      return;
    }

    state = const AsyncValue.data(null);
  }

  Future<void> startManualMixing(
    int motorId,
    double duration,
    double speed,
  ) async {
    assert(duration > 0 && duration <= 1);
    assert(speed > 0 && speed <= 1);

    try {
      state = const AsyncValue.loading();

      log('Throttling motor for candy $motorId');
      final result = await dBusRepository.throttleMotor(
        motorId,
        duration: duration,
        speed: speed,
      );

      if (!result) {
        throw Exception('Failed to start motor $motorId');
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = AsyncValue.error(e, s);
      return;
    }

    state = const AsyncValue.data(null);
  }
}
