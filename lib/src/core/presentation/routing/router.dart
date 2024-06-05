import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final seasonNotifier = ValueNotifier<SeasonState>(SeasonState.idle);
  ref
    ..onDispose(seasonNotifier.dispose)
    ..listen(
      seasonControlProvider,
      (_, next) {
        seasonNotifier.value = next;
      },
    );

  return GoRouter(
    initialLocation: const IdlePageRoute().location,
    routes: $appRoutes,
    refreshListenable: seasonNotifier,
    redirect: (context, state) {
      var seasonState = seasonNotifier.value;
      if (seasonState.isIdle &&
          state.uri.path != const IdlePageRoute().location) {
        return const IdlePageRoute().location;
      }
      if (seasonState.isStarted &&
          state.uri.path == const IdlePageRoute().location) {
        return const GuidePageRoute().location;
      }

      return null;
    },
  );
});
