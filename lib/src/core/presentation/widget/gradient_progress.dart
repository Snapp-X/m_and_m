import 'dart:math' as math;
import 'package:flutter/material.dart';

class GradientProgress extends StatefulWidget {
  const GradientProgress({
    super.key,
    required this.controller,
    this.progressAnimationCurve = Curves.easeInOutQuad,
    this.child,
  });

  final ProgressAnimationController controller;

  final Curve progressAnimationCurve;

  final Widget? child;

  @override
  State<GradientProgress> createState() => _GradientProgressState();
}

class _GradientProgressState extends State<GradientProgress>
    with TickerProviderStateMixin {
  Animation<double> get progressAnimation => _progressAnimation;
  late CurvedAnimation _progressAnimation = _createCurve();

  Tween<double>? _progressValue;

  late List<Color> _colors;

  late List<ColorTween> _colorTweens;

  @override
  void initState() {
    super.initState();

    _colors = widget.controller.colors;
    _colorTweens = List.generate(
      4,
      (index) => ColorTween(begin: Colors.white38),
    );

    _constructTweens();

    _addListeners();
  }

  @override
  void didUpdateWidget(GradientProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progressAnimationCurve != oldWidget.progressAnimationCurve) {
      _progressAnimation.dispose();
      _progressAnimation = _createCurve();
    }
  }

  @override
  void dispose() {
    _progressAnimation.dispose();

    super.dispose();
  }

  CurvedAnimation _createCurve() {
    return CurvedAnimation(
      parent: widget.controller.progressController,
      curve: widget.progressAnimationCurve,
    );
  }

  void _addListeners() {
    widget.controller.addListener(() {
      if (widget.controller.colors != _colors) {
        _colors = widget.controller.colors;

        if (_constructTweens()) {
          forEachTween((Tween<dynamic>? tween, dynamic targetValue,
              TweenConstructor<dynamic> constructor) {
            _updateTween(tween, targetValue);
            return tween;
          });
          widget.controller.progressController
            ..value = 0.0
            ..forward();
        }
      }
    });
  }

  bool _shouldAnimateTween(Tween<dynamic> tween, dynamic targetValue) {
    return targetValue != (tween.end ?? tween.begin);
  }

  void _updateTween(Tween<dynamic>? tween, dynamic targetValue) {
    if (tween == null) {
      return;
    }
    tween
      ..begin = tween.evaluate(_progressAnimation)
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
        widget.controller.moveOutController,
        progressAnimation,
      ]),
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: CircularPaint(
            progressValue: _progressValue!.evaluate(progressAnimation),
            outgoingProgressValue: widget.controller.moveOutAnimation.value,
            borderThickness: 8,
            colors: _colorTweens
                .where((element) => element.begin != null)
                .map((e) => e.evaluate(progressAnimation)!)
                .toList(),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  void forEachTween(TweenVisitor<dynamic> visitor) {
    _progressValue = visitor(
      _progressValue,
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

class ProgressAnimationController extends ChangeNotifier {
  ProgressAnimationController({
    this.colorLimit = 4,
    required TickerProviderStateMixin vsync,
    Duration progressAnimationDuration = const Duration(milliseconds: 700),
    Duration moveOutAnimationDuration = const Duration(milliseconds: 700),
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

  Animation<double> get progressAnimation => progressController.view;
  AnimationController get progressController => _progressController;
  late final AnimationController _progressController;

  Animation<double> get moveOutAnimation => moveOutController.view;
  AnimationController get moveOutController => _moveOutController;
  late final AnimationController _moveOutController;

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
    assert(_colors.length == colorLimit,
        'Colors length must be equal to $colorLimit, Progress should be full to start move out animation');

    if (_moveOutController.isAnimating) return;

    _moveOutController
      ..value = 0.0
      ..forward();

    notifyListeners();
  }
}

double deg2rad(double deg) => deg * math.pi / 180;

class CircularPaint extends CustomPainter {
  /// ring/border thickness, default  it will be 8px [borderThickness].
  final double borderThickness;
  final double progressValue;
  final double outgoingProgressValue;
  final List<Color> colors;

  CircularPaint({
    this.borderThickness = 8.0,
    required this.progressValue,
    this.outgoingProgressValue = 0,
    required this.colors,
  })  : assert(progressValue >= 0 && progressValue <= 1),
        assert(outgoingProgressValue == 0 ||
            (outgoingProgressValue >= 0 && progressValue == 1));

  @override
  void paint(Canvas canvas, Size size) {
    if (progressValue == 0) return;

    Offset center = Offset(size.width / 2, size.height / 2);

    final rect = Rect.fromCenter(
      center: center,
      width: size.width - 10,
      height: size.height - 10,
    );

    if (colors.isEmpty) return;

    final effectiveColors = [
      ...colors,
      colors.first,
    ];

    Paint progressBarPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = borderThickness
      ..shader = SweepGradient(
        tileMode: TileMode.decal,
        colors: effectiveColors,
        transform: GradientRotation(deg2rad(-90)),
      ).createShader(rect);

    canvas.drawArc(
      rect,
      deg2rad(90),
      deg2rad(360 * progressValue),
      false,
      progressBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularPaint oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.borderThickness != borderThickness ||
        oldDelegate.outgoingProgressValue != outgoingProgressValue ||
        oldDelegate.colors != colors;
  }
}
