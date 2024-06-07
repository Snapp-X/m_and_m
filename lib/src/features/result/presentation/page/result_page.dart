import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/result/presentation/widget/result_background_transition.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key, required this.candyBox});

  final CandyBox candyBox;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundColorAnimationController;
  late final AnimationController _contentAnimationController;
  late final Animation<double> _contentAnimation;

  late final colorTween =
      ColorTween(begin: ThemeColors.green, end: ThemeColors.yellow);

  @override
  void initState() {
    super.initState();

    _backgroundColorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )
      ..addStatusListener(_onColorAnimationChange)
      ..forward();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimationController,
        builder: (context, child) {
          return ColoredBox(
            color: colorTween.evaluate(_backgroundColorAnimationController)!,
            child: child,
          );
        },
        child: Stack(
          children: [
            const ResultBackgroundAnimation(),
            PositionedDirectional(
              top: 100,
              end: 100,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ScaleTransition(
                    scale: _contentAnimation,
                    child: FloatingActionButton.large(
                      elevation: 0,
                      backgroundColor: ThemeColors.brown,
                      foregroundColor: ThemeColors.yellow,
                      shape: const CircleBorder(),
                      onPressed: () {
                        ref.read(seasonControlProvider.notifier).idle();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 64,
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _contentAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ENJOY YOUR MIX!',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: ThemeColors.brown,
                              ),
                    ),
                    Text(
                      'A PROJECT BY SNAPP EMBEDDED. MADE WITH FLUTTER.',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: ThemeColors.brown,
                              ),
                    ),
                    const SizedBox(height: 64),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: const Offset(0, 0),
                      ).animate(_contentAnimation),
                      child: RotationTransition(
                        turns: Tween<double>(
                          begin: 0.2,
                          end: 0,
                        ).animate(_contentAnimation),
                        child: const QrCodeWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onColorAnimationChange(state) {
    if (state == AnimationStatus.completed) {
      _contentAnimationController.forward();
    }
  }
}

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: ThemeColors.brown),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Image.asset(
        'assets/img/qr_code.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
