import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.green,
      body: Stack(
        children: [
          PositionedDirectional(
            top: 100,
            end: 100,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return FloatingActionButton.large(
                  elevation: 0,
                  backgroundColor: ThemeColors.darkGreen,
                  shape: const CircleBorder(),
                  onPressed: () {
                    ref.read(seasonControlProvider.notifier).idle();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: ThemeColors.green,
                    size: 64,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'HOW IT WORKS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.darkGreen,
                    fontSize: 100,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'SWIPE LEFT OR RIGHT ON THE BAG \nTO GATHER THE M&MS YOU CRAVE.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 45),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    backgroundColor: ThemeColors.darkGreen,
                    foregroundColor: ThemeColors.green,
                    minimumSize: const Size(200, 100),
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    GoRouter.of(context).go('/mix');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('START'),
                      SizedBox(width: 16),
                      Icon(
                        Icons.east_rounded,
                        color: ThemeColors.green,
                        size: 48,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
