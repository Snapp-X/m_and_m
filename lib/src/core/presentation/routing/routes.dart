import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/features/guide/presentation/page/guide_page.dart';
import 'package:m_and_m/src/features/idle/presentation/page/idle_page.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/page/mix_page.dart';
import 'package:m_and_m/src/features/result/presentation/page/result_page.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

part 'routes.g.dart';

@TypedGoRoute<IdlePageRoute>(
  path: '/',
  name: 'idle',
)
@immutable
class IdlePageRoute extends GoRouteData {
  const IdlePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const IdlePage();
  }
}

@TypedGoRoute<GuidePageRoute>(
  path: '/guide',
  name: 'guide',
)
@immutable
class GuidePageRoute extends GoRouteData {
  const GuidePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: const GuidePage(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return CircularRevealAnimation(
          animation: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}

// Mix path
@TypedGoRoute<MixPageRoute>(
  path: '/mix',
  name: 'mix',
)
@immutable
class MixPageRoute extends GoRouteData {
  const MixPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MixPage();
  }
}

// Result path
@TypedGoRoute<ResultPageRoute>(
  path: '/result',
  name: 'result',
)
@immutable
class ResultPageRoute extends GoRouteData {
  const ResultPageRoute(this.$extra);

  final CandyBox $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ResultPage(candyBox: $extra);
  }
}
