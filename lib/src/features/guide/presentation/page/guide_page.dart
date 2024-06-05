import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/core/presentation/widget/content_body.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.green,
      body: IconTheme(
        data: const IconThemeData(color: ThemeColors.green),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: ThemeColors.darkGreen),
          child: Stack(
            children: [
              PositionedDirectional(
                top: 100,
                end: 100,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return FloatingActionButton.large(
                      elevation: 0,
                      backgroundColor: ThemeColors.darkGreen,
                      foregroundColor: ThemeColors.green,
                      shape: const CircleBorder(),
                      onPressed: () {
                        ref.read(seasonControlProvider.notifier).idle();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ContentBody(
                  title: 'HOW IT WORKS',
                  description:
                      'SWIPE LEFT OR RIGHT ON THE BAG \nTO GATHER THE M&MS YOU CRAVE.',
                  lightColor: ThemeColors.green,
                  darkColor: ThemeColors.darkGreen,
                  onPressed: () {
                    const CatchGameRoute().go(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
