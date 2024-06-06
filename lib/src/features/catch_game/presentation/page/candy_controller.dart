import 'package:flutter/material.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';

class CandyController extends ChangeNotifier {
  CandyController({
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 5),
    Curve curve = Curves.linear,
    required this.color,
    required this.rowPosition,
    bool autoStart = false,
    this.onFallAnimationCompleted,
  }) {
    /// initialize the unique id for each candy controller base on the current time
    id = DateTime.now().millisecond.toString();

    _dyPositionController = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    _dyPositionController.addListener(_dyPositionListener);

    if (onFallAnimationCompleted != null) {
      _dyPositionController.addStatusListener(_onFallAnimationCompleted);
    }

    dyAnimation = CurvedAnimation(
      parent: _dyPositionController,
      curve: curve,
    );

    rotateAnimation = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(_dyPositionController);

    if (autoStart) {
      start();
    }
  }

  late final String id;

  late final AnimationController _dyPositionController;
  late final Animation<double> dyAnimation;
  late final Animation<double> rotateAnimation;

  final CandyColor color;
  final int rowPosition;

  final ValueChanged<String>? onFallAnimationCompleted;

  double dyPosition(double screenHeight, double candySize) =>
      dyAnimation.value * (screenHeight + candySize);

  void start() {
    _dyPositionController.forward();
  }

  void _dyPositionListener() {
    notifyListeners();
  }

  void _onFallAnimationCompleted(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      onFallAnimationCompleted?.call(id);
    }
  }

  @override
  void dispose() {
    _dyPositionController.removeListener(_dyPositionListener);
    if (onFallAnimationCompleted != null) {
      _dyPositionController.removeStatusListener(_onFallAnimationCompleted);
    }

    _dyPositionController.dispose();

    super.dispose();
  }
}
