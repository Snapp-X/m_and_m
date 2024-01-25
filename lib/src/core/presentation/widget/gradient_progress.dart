import 'dart:math' as math;
import 'package:flutter/material.dart';

double deg2rad(double deg) => deg * math.pi / 180;

class GradientProgress extends ImplicitlyAnimatedWidget {
  /// Creates a widget that animates its scale implicitly.
  const GradientProgress({
    super.key,
    this.child,
    required this.colors,
    super.curve,
    required super.duration,
    super.onEnd,
  }) : assert(colors.length <= 4);

  final Widget? child;

  final List<Color> colors;

  @override
  ImplicitlyAnimatedWidgetState<GradientProgress> createState() =>
      _GradientProgressState();
}

class _GradientProgressState
    extends ImplicitlyAnimatedWidgetState<GradientProgress> {
  Tween<double>? _progressValue;

  // late Animation<double> _progressAnimation;

  List<ColorTween> colorTweens = [
    ColorTween(begin: Colors.white38),
    ColorTween(),
    ColorTween(),
    ColorTween(),
  ];

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    print(widget.colors.length);
    _progressValue = visitor(
      _progressValue,
      (widget.colors.length * .25),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    print('progressValue: $_progressValue');

    if (widget.colors.isEmpty) return;

    colorTweens = List.generate(4, (index) {
      if (index < widget.colors.length) {
        return visitor(
          colorTweens[index],
          widget.colors[index],
          (dynamic value) => ColorTween(begin: value as Color),
        ) as ColorTween;
      }

      return visitor(
        colorTweens[index],
        widget.colors[widget.colors.length - 1],
        (dynamic value) => ColorTween(begin: value as Color),
      ) as ColorTween;
    });

    print('colorTweens: ${colorTweens.map((e) => e.begin)}');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: CircularPaint(
            progressValue: _progressValue!.evaluate(animation),
            borderThickness: 8,
            colors: colorTweens
                .where((element) => element.begin != null)
                .map((e) => e.evaluate(animation)!)
                .toList(),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

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
      deg2rad(-90),
      deg2rad(360 * progressValue),
      false,
      progressBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularPaint oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.borderThickness != borderThickness;
  }
}
