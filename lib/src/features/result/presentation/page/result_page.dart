import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/config.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/features/result/presentation/provider/make_mix_provider.dart';
import 'package:m_and_m/src/features/result/presentation/widget/result_background_transition.dart';

enum GameResult { win, lose }

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key, required this.gameResult});

  final GameResult gameResult;

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
  void dispose() {
    _backgroundColorAnimationController.dispose();
    _contentAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(makeMixNotifierProvider, (previous, current) {
      if (current is AsyncData) {
        log('Mixing completed');
      }
    });

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
                    SizedBox(
                      width: 1100,
                      child: Text(
                        widget.gameResult == GameResult.win
                            ? 'ENJOY YOUR MIX!'
                            : 'OOPS, WRONG ORDER! TRY AGAIN.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: ThemeColors.brown,
                                ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'A PROJECT BY SNAPP X. MADE WITH FLUTTER.',
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
      if (widget.gameResult == GameResult.win) {
        _startDbusConnection();
      }
    }
  }

  void _startDbusConnection() {
    ref.read(makeMixNotifierProvider.notifier).startManualMixing(
          MotorDbusController.dispenserMotorId,
          MotorDbusController.defaultThrottleDuration,
          MotorDbusController.defaultThrottleMotorSpeed,
        );
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
