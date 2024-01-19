import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final seasonControlProvider =
    StateNotifierProvider<SeasonControlProvider, SeasonState>((ref) {
  return SeasonControlProvider();
});

enum SeasonState {
  idle,
  started,
  interacting,
  completed;

  bool get isIdle => this == SeasonState.idle;
  bool get isStarted => this == SeasonState.started;
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
        log('timer expired');
        state = SeasonState.idle;
      },
    );
  }

  void idle() {
    log('idle');
    state = SeasonState.idle;
    _timer?.cancel();
  }

  void startSeason() {
    log('startSeason');
    state = SeasonState.started;
    _startTimer();
  }

  void interacted() {
    log('interacted');
    state = SeasonState.interacting;
    _startTimer();
  }

  void completed() {
    log('completed');
    state = SeasonState.completed;
    _startTimer();
  }

  void reset() {
    log('reset');
    state = SeasonState.idle;
    _timer?.cancel();
  }
}
