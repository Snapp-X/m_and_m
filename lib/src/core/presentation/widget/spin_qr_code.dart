import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/presentation/widget/spin_in_progress.dart';

class SpinQrCodeWidget extends ConsumerStatefulWidget {
  const SpinQrCodeWidget({super.key, required this.candyBox});

  final CandyBox candyBox;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends ConsumerState<SpinQrCodeWidget>
    with TickerProviderStateMixin {
  late final SpinInProgressController _progressAnimationController;

  final ValueNotifier<bool> _isQrCodeVisible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _progressAnimationController = SpinInProgressController(
      vsync: this,
      colors: widget.candyBox.portions.values.map((e) => e.color).toList(),
    );

    _progressAnimationController.moveInAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAnimationCompleted();
      }
    });

    _progressAnimationController.startMoveInAnimation();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final mixResult = ref.watch(makeMixNotifierProvider);

    return SpinInProgress(
      controller: _progressAnimationController,
      child: Container(
        width: 230,
        height: 230,
        decoration: ShapeDecoration(
          color: const Color(0xFF24272C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(42),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(5, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white24,
              blurRadius: 20,
              offset: Offset(-5, -5),
              spreadRadius: 0,
            )
          ],
        ),
        child: ValueListenableBuilder(
          valueListenable: _isQrCodeVisible,
          builder: (context, isQrCodeVisible, child) {
            return AnimatedOpacity(
              opacity: isQrCodeVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/img/qr-code.png',
                width: 220,
                height: 220,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onAnimationCompleted() {
    _isQrCodeVisible.value = true;
    // ref.read(makeMixNotifierProvider.notifier).startMixing(widget.candyBox);
  }
}
