import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpinOutProgress extends StatefulWidget {
  const SpinOutProgress({
    super.key,
    required this.controller,
    this.curve = Curves.easeInOutQuad,
    this.child,
  });

  final SpinOutProgressController controller;

  final Curve curve;

  final Widget? child;

  @override
  State<SpinOutProgress> createState() => _SpinOutProgressState();
}

class _SpinOutProgressState extends State<SpinOutProgress>
    with TickerProviderStateMixin {
  // animation is used to spin the progress
  Animation<double> get spinAnimation => _spinAnimation;
  late CurvedAnimation _spinAnimation =
      _createCurve(widget.controller.spinController);

  Animation<double> get moveOutAnimation => _moveOutAnimation;
  late CurvedAnimation _moveOutAnimation =
      _createCurve(widget.controller.moveOutAnimation);

  Tween<double>? _spinValueTween;

  late List<Color> _colors;

  late List<ColorTween> _colorTweens;

  @override
  void initState() {
    super.initState();

    _colors = widget.controller.colors;
    _colorTweens = List.generate(
      widget.controller.colorLimit,
      (index) => ColorTween(begin: Colors.white38),
    );

    _constructTweens();

    _addListeners();
  }

  @override
  void didUpdateWidget(SpinOutProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.curve != oldWidget.curve) {
      _spinAnimation.dispose();
      _spinAnimation = _createCurve(widget.controller.spinController);
      _moveOutAnimation.dispose();
      _moveOutAnimation = _createCurve(widget.controller.moveOutAnimation);
    }
  }

  @override
  void dispose() {
    _spinAnimation.dispose();

    super.dispose();
  }

  CurvedAnimation _createCurve(Animation<double> parent) {
    return CurvedAnimation(
      parent: parent,
      curve: widget.curve,
    );
  }

  void _addListeners() {
    widget.controller.addListener(
      () {
        if (widget.controller.colors != _colors) {
          _colors = widget.controller.colors;

          if (_constructTweens()) {
            forEachTween((Tween<dynamic>? tween, dynamic targetValue,
                TweenConstructor<dynamic> constructor) {
              _updateTween(tween, targetValue);
              return tween;
            });
            widget.controller.spinController
              ..value = 0.0
              ..forward();
          }
        }
      },
    );
  }

  bool _shouldAnimateTween(Tween<dynamic> tween, dynamic targetValue) {
    return targetValue != (tween.end ?? tween.begin);
  }

  void _updateTween(Tween<dynamic>? tween, dynamic targetValue) {
    if (tween == null) {
      return;
    }
    tween
      ..begin = tween.evaluate(_spinAnimation)
      ..end = targetValue;
  }

  bool _constructTweens() {
    bool shouldStartAnimation = false;
    forEachTween((Tween<dynamic>? tween, dynamic targetValue,
        TweenConstructor<dynamic> constructor) {
      if (targetValue != null) {
        tween ??= constructor(targetValue);
        if (_shouldAnimateTween(tween, targetValue)) {
          shouldStartAnimation = true;
        } else {
          tween.end ??= tween.begin;
        }
      } else {
        tween = null;
      }
      return tween;
    });
    return shouldStartAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        moveOutAnimation,
        spinAnimation,
      ]),
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _SpinOutPainter(
            spinProgressValue: _spinValueTween!.evaluate(spinAnimation),
            outgoingProgressValue: moveOutAnimation.value,
            borderThickness: 8,
            colors: _colorTweens
                .where((element) => element.begin != null)
                .map((e) => e.evaluate(spinAnimation)!)
                .toList(),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  void forEachTween(TweenVisitor<dynamic> visitor) {
    _spinValueTween = visitor(
      _spinValueTween,
      (_colors.length * .25),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    if (_colors.isEmpty) return;

    _colorTweens = List.generate(4, (index) {
      if (index < _colors.length) {
        return visitor(
          _colorTweens[index],
          _colors[index],
          (dynamic value) => ColorTween(begin: value as Color),
        ) as ColorTween;
      }

      return visitor(
        _colorTweens[index],
        _colors[_colors.length - 1],
        (dynamic value) => ColorTween(begin: value as Color),
      ) as ColorTween;
    });
  }
}

class SpinOutProgressController extends ChangeNotifier {
  SpinOutProgressController({
    this.colorLimit = 4,
    required TickerProviderStateMixin vsync,
    Duration progressAnimationDuration = const Duration(milliseconds: 700),
    Duration moveOutAnimationDuration = const Duration(milliseconds: 3000),
  }) {
    _progressController = AnimationController(
      duration: progressAnimationDuration,
      vsync: vsync,
    );

    _moveOutController = AnimationController(
      duration: moveOutAnimationDuration,
      vsync: vsync,
    );
  }

  final int colorLimit;

  final List<Color> _colors = [];
  List<Color> get colors => _colors.toList();

  Animation<double> get progressAnimation => spinController.view;
  AnimationController get spinController => _progressController;
  late final AnimationController _progressController;

  Animation<double> get moveOutAnimation => moveOutController.view;
  AnimationController get moveOutController => _moveOutController;
  late final AnimationController _moveOutController;

  @override
  void dispose() {
    super.dispose();

    _progressController.dispose();
    _moveOutController.dispose();
  }

  void addColor(Color color) {
    if (_colors.length >= colorLimit) return;

    _colors.add(color);
    notifyListeners();
  }

  void removeColor(Color color) {
    if (!_colors.contains(color)) return;

    _colors.remove(color);
    notifyListeners();
  }

  void startMoveOutAnimation() {
    if (_colors.length < colorLimit &&
        _progressController.status == AnimationStatus.completed) return;

    if (!_moveOutController.isDismissed) return;

    _moveOutController
      ..value = 0.0
      ..forward();

    notifyListeners();
  }
}

double deg2rad(double deg) => deg * math.pi / 180;

class _SpinOutPainter extends CustomPainter {
  _SpinOutPainter({
    this.borderThickness = 8.0,
    this.spinProgressValue = 0,
    this.outgoingProgressValue = 0,
    required this.colors,
  })  : assert(spinProgressValue >= 0 && spinProgressValue <= 1),
        assert(outgoingProgressValue == 0 ||
            (outgoingProgressValue >= 0 && spinProgressValue == 1)),
        progressBarPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = borderThickness;

  final double borderThickness;
  final double spinProgressValue;
  final double outgoingProgressValue;

  final double outGoingMultiplier = 150;

  final List<Color> colors;
  final Paint progressBarPaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (spinProgressValue == 0 || colors.isEmpty) return;

    Offset center = Offset(size.width / 2, size.height / 2);

    final rect = Rect.fromCenter(
      center: center,
      width: size.width - 10,
      height: size.height - 10,
    );

    final effectiveColors = [
      ...colors,
      colors.first,
    ];

    const startGoingOutPoint = .75;

    final fillOutValue = convertRange(
      0,
      startGoingOutPoint,
      0,
      1,
      outgoingProgressValue.clamp(0, startGoingOutPoint),
    );

    final outGoingValue = convertRange(
      startGoingOutPoint,
      1,
      0,
      1,
      outgoingProgressValue.clamp(startGoingOutPoint, 1),
    );

    progressBarPaint.shader = SweepGradient(
      tileMode: TileMode.decal,
      colors: effectiveColors,
      transform: GradientRotation(deg2rad(90 + (360 * fillOutValue))),
    ).createShader(rect);

    final Path path = Path();

    if (spinProgressValue == 1 && outgoingProgressValue > 0) {
      path.addArc(
        rect,
        deg2rad(90 + (360 * fillOutValue)),
        deg2rad(360 - (360 * fillOutValue)),
      );

      final lineStartingPoint = Offset(
        size.width / 2,
        size.height -
            (borderThickness / 2) +
            (outGoingValue * outGoingMultiplier),
      );

      path.moveTo(
        lineStartingPoint.dx,
        lineStartingPoint.dy,
      );

      path.lineTo(
        lineStartingPoint.dx,
        lineStartingPoint.dy + (outGoingMultiplier * fillOutValue),
      );
    } else if (spinProgressValue <= 1) {
      path.addArc(
        rect,
        deg2rad(90),
        deg2rad(360 * spinProgressValue),
      );
    } else {
      return;
    }

    canvas.drawPath(
      path,
      progressBarPaint,
    );
  }

  double convertRange(
    double originalStart,
    double originalEnd,
    double newStart,
    double newEnd,
    double value,
  ) {
    double scale = (newEnd - newStart) / (originalEnd - originalStart);
    return (newStart + ((value - originalStart) * scale));
  }

  @override
  bool shouldRepaint(covariant _SpinOutPainter oldDelegate) {
    return oldDelegate.spinProgressValue != spinProgressValue ||
        oldDelegate.borderThickness != borderThickness ||
        oldDelegate.outgoingProgressValue != outgoingProgressValue ||
        oldDelegate.colors != colors;
  }
}
