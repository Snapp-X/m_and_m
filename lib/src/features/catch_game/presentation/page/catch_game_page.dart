
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/features/catch_game/presentation/provider/catch_game_const.dart';
import 'package:m_and_m/src/features/catch_game/presentation/provider/catch_game_controller.dart';
import 'package:m_and_m/src/features/catch_game/presentation/widget/cache_widget.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

// TODO(payam): add precache logic for images
class CacheGamePage extends StatelessWidget {
  const CacheGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ThemeColors.green,
      body: Game(),
    );
  }
}

class Game extends ConsumerStatefulWidget {
  const Game({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> with TickerProviderStateMixin {
  late final CacheGameController gameController;

  @override
  void initState() {
    super.initState();

    gameController = CacheGameController(
      vsync: this,
      screenSizeProvider: () => MediaQuery.of(context).size,
      onCandyCatch: (color) {
        ref.read(candyMixerProvider.notifier).addCandy(color);
      },
    );

    gameController.candyControllers.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gameController.startGame();

      final screenSize = MediaQuery.of(context).size;

      /// Set initial bag position
      gameController.updateBagPosition(
          screenSize.center(Offset.zero), screenSize);
    });
  }

  @override
  void dispose() {
    gameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Listen to the candy box to finish the game when the limit is reached
    ref.listen(
      candyMixerProvider,
      (previous, next) {
        if (next.portions.length ==
            ref.read(candyMixerProvider.notifier).limit) {
          finishGame(next);
        }
      },
    );

    final screenSize = MediaQuery.of(context).size;
    final rowCount = candyRowCount(context);
    final outerPadding = (screenSize.width - rowCount * candyRowWidth) / 2;

    final List<Widget> candyRows = [
      for (var i = 0; i < rowCount; i++)
        Positioned(
          left: outerPadding + i * candyRowWidth,
          top: 0,
          child: Container(
            width: candyRowWidth,
            height: screenSize.height,
            color: [Colors.white54, Colors.white70][i % 2],
          ),
        ),
    ];

    return GestureDetector(
      child: Stack(
        children: [
          ...candyRows,

          /// Falling candies
          for (var controller in gameController.candyControllers.value)
            if (controller.rowPosition < rowCount)
              AnimatedBuilder(
                animation: Listenable.merge(
                  [
                    gameController.candyControllers,
                    controller.dyAnimation,
                    controller.rotateAnimation,
                    controller.fadeOutAnimation,
                  ],
                ),
                builder: (context, child) {
                  final dx = controller.dxPosition(
                    outerPadding,
                    candyOuterPadding,
                    candySize,
                  );

                  final dy =
                      controller.dyPosition(screenSize.height, candySize);

                  return Positioned(
                    left: dx,
                    top: dy,
                    child: RotationTransition(
                      turns: controller.rotateAnimation,
                      child: ScaleTransition(
                        scale: controller.fadeOutAnimation,
                        child: Candy(color: controller.color),
                      ),
                    ),
                  );
                },
              ),

          /// Bag widget
          ValueListenableBuilder(
            valueListenable: gameController.bagPosition,
            child: GestureDetector(
              onPanUpdate: (details) => gameController.updateBagPosition(
                details.globalPosition,
                screenSize,
              ),
              child: const BagWidget(),
            ),
            builder: (context, Offset position, child) {
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: child!,
              );
            },
          ),

          PositionedDirectional(
            top: 100,
            start: 100,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
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
          const Positioned(
            top: 100,
            right: 100,
            child: CollectedCandiesWidget(),
          ),
        ],
      ),
    );
  }

  void finishGame(candyBox) {
    gameController.finishGame();

    // ResultPageRoute(candyBox).go(context);
  }

  int candyRowCount(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width ~/ candyRowWidth;
  }
}
