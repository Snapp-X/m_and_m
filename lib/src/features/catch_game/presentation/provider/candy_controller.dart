import 'package:flutter/material.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';

const _fadeOutDuration = Duration(milliseconds: 400);

/// The candy controller is a class that controls the candy animation
/// It is responsible for the candy falling down and fading out animation
class CandyController extends ChangeNotifier {
  CandyController({
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 5),
    Curve curve = Curves.linear,
    required this.color,
    required this.rowPosition,
    bool autoStart = false,
    this.onFallAnimationCompleted,
    this.onPositionChanged,
  }) {
    /// initialize the unique id for each candy controller base on the current time
    id = DateTime.now().millisecondsSinceEpoch.toString();

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
      end: 2,
    ).animate(_dyPositionController);

    _fadeOutController = AnimationController(
      vsync: vsync,
      duration: _fadeOutDuration,
    );

    _fadeOutController.addListener(_fadeOutListener);
    _fadeOutController.addStatusListener(_onFallAnimationCompleted);

    fadeOutAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _fadeOutController,
        curve: Curves.easeOutQuad,
      ),
    );

    if (autoStart) {
      startFalling();
    }
  }

  late final String id;

  late final AnimationController _dyPositionController;
  late final Animation<double> dyAnimation;
  late final Animation<double> rotateAnimation;

  late final AnimationController _fadeOutController;
  late final Animation<double> fadeOutAnimation;

  final CandyColor color;
  final int rowPosition;

  final ValueChanged<String>? onFallAnimationCompleted;
  final ValueChanged<String>? onPositionChanged;

  /// calculate the x position of the candy
  double dxPosition(
          double outerPadding, double candyOuterPadding, double candySize) =>
      (candyOuterPadding / 2) +
      (outerPadding) +
      rowPosition * (candySize + candyOuterPadding);

  /// calculate the y position of the candy
  double dyPosition(double screenHeight, double candySize) =>
      _fallingDownDyPosition(screenHeight, candySize) -
      _fadeOutDyPosition(screenHeight, candySize);

  double _fallingDownDyPosition(double screenHeight, double candySize) =>
      dyAnimation.value * (screenHeight + candySize) - candySize;

  double _fadeOutDyPosition(double screenHeight, double candySize) =>
      fadeOutAnimation.isDismissed
          ? 0
          : (-1 + fadeOutAnimation.value) * candySize;

  void startFalling() {
    _dyPositionController.forward();
  }

  void startFadeOut() {
    _dyPositionController.stop();
    _fadeOutController.forward();
  }

  void _dyPositionListener() {
    onPositionChanged?.call(id);
    notifyListeners();
  }

  void _fadeOutListener() {
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

    _fadeOutController.removeListener(_fadeOutListener);
    _fadeOutController.removeStatusListener(_onFallAnimationCompleted);

    super.dispose();
  }
}
