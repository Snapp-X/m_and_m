import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final seasonControlProvider =
    StateNotifierProvider<SeasonControlProvider, SeasonState>((ref) {
  return SeasonControlProvider();
});

enum SeasonState {
  idle,
  interacting,
  completed;

  bool get isIdle => this == SeasonState.idle;
  bool get isInteracting => this == SeasonState.interacting;
  bool get isCompleted => this == SeasonState.completed;
}

const _timeoutToIdle = Duration(seconds: 5);

class SeasonControlProvider extends StateNotifier<SeasonState> {
  SeasonControlProvider() : super(SeasonState.idle);

  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(
      _timeoutToIdle,
      () {
        print('timer expired');
        state = SeasonState.idle;
      },
    );
  }

  void idle() {
    print('idle');
    state = SeasonState.idle;
    _timer?.cancel();
  }

  void interacted() {
    print('interacted');
    state = SeasonState.interacting;
    _startTimer();
  }

  void completed() {
    print('completed');
    state = SeasonState.completed;
    _startTimer();
  }
}
