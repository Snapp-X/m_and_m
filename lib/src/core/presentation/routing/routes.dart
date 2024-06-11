import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/core/presentation/routing/page_transition.dart';
import 'package:m_and_m/src/features/catch_game/presentation/page/catch_game_page.dart';
import 'package:m_and_m/src/features/guide/presentation/page/guide_page.dart';
import 'package:m_and_m/src/features/idle/presentation/page/idle_page.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/page/mix_page.dart';
import 'package:m_and_m/src/features/result/presentation/page/result_page.dart';

part 'routes.g.dart';

const _kPageTransitionAnimationDuration = Duration(milliseconds: 600);

@TypedGoRoute<IdlePageRoute>(
  path: '/',
  name: 'idle',
)
@immutable
class IdlePageRoute extends GoRouteData {
  const IdlePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DefaultPageTransition(
      key: state.pageKey,
      child: const IdlePage(),
    );
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
      transitionDuration: _kPageTransitionAnimationDuration,
      reverseTransitionDuration: _kPageTransitionAnimationDuration,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return CircularRevealAnimation(
          animation: CurveTween(curve: Curves.easeInOut).animate(animation),
          centerAlignment: const Alignment(0, 0.8),
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
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DefaultPageTransition(
      key: state.pageKey,
      child: const MixPage(),
    );
  }
}

//
@TypedGoRoute<CatchGameRoute>(
  path: '/catch-game',
  name: 'catch-game',
)
@immutable
class CatchGameRoute extends GoRouteData {
  const CatchGameRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DefaultPageTransition(
      key: state.pageKey,
      child: const CatchGamePage(),
    );
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
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DefaultPageTransition(
      key: state.pageKey,
      child: ResultPage(candyBox: $extra),
    );
  }
}
