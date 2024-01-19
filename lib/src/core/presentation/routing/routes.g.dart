// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $idlePageRoute,
      $mixPageRoute,
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

RouteBase get $resultPageRoute => GoRouteData.$route(
      path: '/result',
      name: 'result',
      factory: $ResultPageRouteExtension._fromState,
    );

extension $ResultPageRouteExtension on ResultPageRoute {
  static ResultPageRoute _fromState(GoRouterState state) =>
      const ResultPageRoute();

  String get location => GoRouteData.$location(
        '/result',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
