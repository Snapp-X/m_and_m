import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

const kTransitionAnimationDuration = Duration(milliseconds: 600);

class DefaultPageTransition<T> extends CustomTransitionPage<T> {
  const DefaultPageTransition({
    required super.key,
    required super.child,
    super.transitionsBuilder = _defaultTransitionsBuilder,
    super.transitionDuration = kTransitionAnimationDuration,
    super.reverseTransitionDuration = kTransitionAnimationDuration,
  });
}

Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  final effectiveAnimation =
      secondaryAnimation.status == AnimationStatus.dismissed
          ? animation
          : Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation);

  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeOut).animate(effectiveAnimation),
    child: child,
  );
}
