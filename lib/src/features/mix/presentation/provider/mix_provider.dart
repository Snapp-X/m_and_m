import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';

final candyMixerProvider =
    StateNotifierProvider.autoDispose<CandyMixerNotifier, CandyBox>(
  (ref) {
    return CandyMixerNotifier();
  },
);

class CandyMixerNotifier extends StateNotifier<CandyBox> {
  CandyMixerNotifier() : super(const CandyBox());

  final int limit = 4;

  void addCandy(CandyColor color) {
    if (state.portions.length == limit) return;

    state = state.copyWith(
      portions: Map<int, CandyColor>.from(state.portions)
        ..update(
          state.portions.length,
          (value) => color,
          ifAbsent: () => color,
        ),
    );
  }
}
