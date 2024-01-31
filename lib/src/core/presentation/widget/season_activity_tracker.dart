import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';

class SeasonActivityTracker extends ConsumerWidget {
  const SeasonActivityTracker({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        log('SeasonActivityTracker: onTap');
        _submitActivity(ref);
      },
      onPanDown: (_) {
        log('SeasonActivityTracker: onPanDown');
        _submitActivity(ref);
      },
      child: child,
    );
  }

  void _submitActivity(WidgetRef ref) {
    ref.read(seasonControlProvider.notifier).interacted();
  }
}
