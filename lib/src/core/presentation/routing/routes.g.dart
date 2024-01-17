// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $idlePageRoute,
      $makePageRoute,
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

RouteBase get $makePageRoute => GoRouteData.$route(
      path: '/make',
      name: 'make',
      factory: $MakePageRouteExtension._fromState,
    );

extension $MakePageRouteExtension on MakePageRoute {
  static MakePageRoute _fromState(GoRouterState state) => const MakePageRoute();

  String get location => GoRouteData.$location(
        '/make',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
