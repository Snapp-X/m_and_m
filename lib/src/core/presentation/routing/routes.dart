import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/features/idle/presentation/page/idle_page.dart';
import 'package:m_and_m/src/features/make/presentation/page/make_page.dart';
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

// Make path
@TypedGoRoute<MakePageRoute>(
  path: '/make',
  name: 'make',
)
@immutable
class MakePageRoute extends GoRouteData {
  const MakePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MakePage();
  }
}

// Result path
@TypedGoRoute<ResultPageRoute>(
  path: '/result',
  name: 'result',
)
@immutable
class ResultPageRoute extends GoRouteData {
  const ResultPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ResultPage();
  }
}
