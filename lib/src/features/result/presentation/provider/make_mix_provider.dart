import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/domain/repository/dbus_repository.dart';

final makeMixNotifierProvider =
    StateNotifierProvider.autoDispose<MakeMixNotifier, AsyncValue<CandyBox>?>(
  (ref) => MakeMixNotifier(dBusRepository: ref.read(dBusRepositoryProvider)),
);

class MakeMixNotifier extends StateNotifier<AsyncValue<CandyBox>?> {
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

    state = AsyncValue.data(candyBox);
  }

  Future<void> startPortioning(int numberOfPortions) async {
    final duration = 0.5 * numberOfPortions;

    try {
      state = const AsyncValue.loading();
      log('Throttling motor for candy for $numberOfPortions portions');
      final result = await dBusRepository.throttleMotor(0, duration: duration);

      if (!result) {
        throw Exception('Failed to start motor 0');
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = AsyncValue.error(e, s);
      return;
    }

    state = const AsyncValue.data(CandyBox());
  }
}
