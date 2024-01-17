import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final seasonState = ValueNotifier<SeasonState>(SeasonState.idle);
  ref
    ..onDispose(seasonState.dispose)
    ..listen(
      seasonControlProvider,
      (_, next) {
        seasonState.value = next;
      },
    );

  return GoRouter(
    initialLocation: const IdlePageRoute().location,
    routes: $appRoutes,
    refreshListenable: seasonState,
    redirect: (context, state) {
      if (seasonState.value.isIdle &&
          state.uri.path != const IdlePageRoute().location) {
        return const IdlePageRoute().location;
      }

      return null;
    },
  );
});
