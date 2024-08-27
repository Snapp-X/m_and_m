// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $idlePageRoute,
      $guidePageRoute,
      $mixPageRoute,
      $catchGameRoute,
      $resultPageRoute,
    ];

RouteBase get $idlePageRoute => GoRouteData.$route(
      path: '/',
      name: 'idle',
      factory: $IdlePageRouteExtension._fromState,
    );

extension $IdlePageRouteExtension on IdlePageRoute {
  static IdlePageRoute _fromState(GoRouterState state) => const IdlePageRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $guidePageRoute => GoRouteData.$route(
      path: '/guide',
      name: 'guide',
      factory: $GuidePageRouteExtension._fromState,
    );

extension $GuidePageRouteExtension on GuidePageRoute {
  static GuidePageRoute _fromState(GoRouterState state) =>
      const GuidePageRoute();

  String get location => GoRouteData.$location(
        '/guide',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mixPageRoute => GoRouteData.$route(
      path: '/mix',
      name: 'mix',
      factory: $MixPageRouteExtension._fromState,
    );

extension $MixPageRouteExtension on MixPageRoute {
  static MixPageRoute _fromState(GoRouterState state) => const MixPageRoute();

  String get location => GoRouteData.$location(
        '/mix',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $catchGameRoute => GoRouteData.$route(
      path: '/catch-game',
      name: 'catch-game',
      factory: $CatchGameRouteExtension._fromState,
    );

extension $CatchGameRouteExtension on CatchGameRoute {
  static CatchGameRoute _fromState(GoRouterState state) => CatchGameRoute(
        state.extra as CandyBox,
      );

  String get location => GoRouteData.$location(
        '/catch-game',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $resultPageRoute => GoRouteData.$route(
      path: '/result',
      name: 'result',
      factory: $ResultPageRouteExtension._fromState,
    );

extension $ResultPageRouteExtension on ResultPageRoute {
  static ResultPageRoute _fromState(GoRouterState state) => ResultPageRoute(
        state.extra as GameResult,
      );

  String get location => GoRouteData.$location(
        '/result',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
