import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/features/idle/presentation/page/idle_page.dart';
import 'package:m_and_m/src/features/make/presentation/page/make_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
});

final routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const IdlePage(),
  ),
  GoRoute(
    path: '/make',
    builder: (context, state) => const MakePage(),
  ),
];
