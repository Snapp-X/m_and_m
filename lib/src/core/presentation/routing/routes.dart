import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/features/idle/presentation/page/idle_page.dart';
import 'package:m_and_m/src/features/mix/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/page/mix_page.dart';
import 'package:m_and_m/src/features/result/presentation/page/result_page.dart';

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
