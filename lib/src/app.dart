import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/routing/router.dart';
import 'package:m_and_m/src/core/presentation/theme/theme.dart';
import 'package:m_and_m/src/core/presentation/widget/season_activity_tracker.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(routerProvider);

    return SeasonActivityTracker(
      child: MaterialApp.router(
        title: 'M&M',
        routerConfig: appRouter,
        theme: buildTheme(),
      ),
    );
  }
}
