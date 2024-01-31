import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpinInProgress extends StatefulWidget {
  const SpinInProgress({
    super.key,
    required this.controller,
    this.curve = Curves.easeInOutQuad,
    this.child,
  });

  final SpinInProgressController controller;

  final Curve curve;

  final Widget? child;

  @override
  State<SpinInProgress> createState() => _SpinInProgressState();
}

class _SpinInProgressState extends State<SpinInProgress> {
  Animation<double> get moveInAnimation => _moveInAnimation;
  late CurvedAnimation _moveInAnimation =
      _createCurve(widget.controller.moveInAnimation);

  @override
  void didUpdateWidget(SpinInProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.curve != oldWidget.curve) {
      _moveInAnimation.dispose();
      _moveInAnimation = _createCurve(widget.controller.moveInAnimation);
    }
  }

  @override
  void dispose() {
    _moveInAnimation.dispose();

    super.dispose();
  }

  CurvedAnimation _createCurve(Animation<double> parent) {
    return CurvedAnimation(
      parent: parent,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: moveInAnimation,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _SpinInPainter(
            enteringProgressValue: moveInAnimation.value,
            colors: widget.controller.colors,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SpinInProgressController extends ChangeNotifier {
  SpinInProgressController({
    required List<Color> colors,
    required TickerProviderStateMixin vsync,
    Duration moveOutAnimationDuration = const Duration(milliseconds: 3000),
  }) {
    _colors = colors;
    _moveInController = AnimationController(
      duration: moveOutAnimationDuration,
      vsync: vsync,
    );
  }

  late final List<Color> _colors;
  List<Color> get colors => _colors.toList();

  Animation<double> get moveInAnimation => moveInController.view;
  AnimationController get moveInController => _moveInController;
  late final AnimationController _moveInController;

  void startMoveInAnimation() {
    if (!_moveInController.isDismissed) return;

    _moveInController
      ..value = 0.0
      ..forward();

    notifyListeners();
  }
}

double deg2rad(double deg) => deg * math.pi / 180;

class _SpinInPainter extends CustomPainter {
  _SpinInPainter({
    this.borderThickness = 8.0,
    this.enteringProgressValue = 0,
    required this.colors,
  })  : assert(enteringProgressValue >= 0 && enteringProgressValue <= 1),
        progressBarPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = borderThickness;

  final double borderThickness;
  final double enteringProgressValue;
  final List<Color> colors;

  final Paint progressBarPaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;
    if (enteringProgressValue <= 0) return;

    Offset center = Offset(size.width / 2, size.height / 2);

    final rect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );

    final effectiveColors = [
      ...colors,
      colors.first,
    ];

    final incomingValue =
        convertRange(0, .5, 0, 1, enteringProgressValue.clamp(0, .5));

    final fillOutValue =
        convertRange(.5, 1, 0, 1, enteringProgressValue.clamp(.5, 1));

    progressBarPaint.shader = SweepGradient(
      tileMode: TileMode.decal,
      colors: effectiveColors,
      transform: GradientRotation(deg2rad(-90 + (360 * enteringProgressValue))),
    ).createShader(rect);

    final Path path = Path();

    final lineStartingPoint = Offset(
      size.width / 2,
      -(300 - (300 * fillOutValue)),
    );

    path.moveTo(
      lineStartingPoint.dx,
      lineStartingPoint.dy,
    );

    path.lineTo(
      lineStartingPoint.dx,
      lineStartingPoint.dy + (incomingValue * 300) - (fillOutValue * 300),
    );

    if (fillOutValue > 0) {
      double x = math.min(size.height, size.width);
      double x2 = x / 2;
      double x4 = x / 4;

      // Createing rounded rectangle path
      Path rectanglePath = Path()
        ..moveTo(x2, x)
        ..lineTo(x4, x)
        ..quadraticBezierTo(0, x, 0, x - x4)
        ..lineTo(0, x4)
        ..quadraticBezierTo(0, 0, x4, 0)
        ..lineTo(x - x4, 0)
        ..quadraticBezierTo(x, 0, x, x4)
        ..lineTo(x, x - x4)
        ..quadraticBezierTo(x, x, x - x4, x)
        ..lineTo(x2, x);

      final rectanglePathMetric = rectanglePath.computeMetrics().first;

      Path rectangleBorderPath = rectanglePathMetric.extractPath(
        rectanglePathMetric.length * (0.5 * (1 - fillOutValue)),
        rectanglePathMetric.length * (0.5 + 0.5 * fillOutValue),
        startWithMoveTo: true,
      );

      path.addPath(rectangleBorderPath, Offset.zero);
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
  bool shouldRepaint(covariant _SpinInPainter oldDelegate) {
    return oldDelegate.borderThickness != borderThickness ||
        oldDelegate.enteringProgressValue != enteringProgressValue ||
        oldDelegate.colors != colors;
  }
}
