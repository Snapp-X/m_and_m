import 'package:flutter_riverpod/flutter_riverpod.dart';

final singleDispenseProvider =
    StateNotifierProvider.autoDispose<SingleDispenseNotifier, int>(
  (ref) {
    return SingleDispenseNotifier();
  },
);

class SingleDispenseNotifier extends StateNotifier<int> {
  SingleDispenseNotifier() : super(2);

  final int limit = 5;

  void updatePortionSize(int value) {
    if (state == limit) return;

    state = value;
  }
}
