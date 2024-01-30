import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

const _stateMachineName = 'Interactive MnMs';

final backgroundRiveProvider = FutureProvider<RiveFile>((ref) async {
  final data = await rootBundle.load('assets/rive/m_and_m.riv');

  final riveFile = RiveFile.import(data);

  return riveFile;
});

class BackgroundAnimation extends ConsumerStatefulWidget {
  const BackgroundAnimation({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BackgroundAnimationState();
}

class _BackgroundAnimationState extends ConsumerState<BackgroundAnimation> {
  @override
  Widget build(BuildContext context) {
    final lampFile = ref.watch(backgroundRiveProvider);

    final background = lampFile.maybeWhen(
      data: (data) {
        return RiveAnimation.direct(
          data,
          onInit: (art) {
            final controller = StateMachineController.fromArtboard(
              art,
              _stateMachineName,
            ) as StateMachineController;

            controller.isActive = true;

            art.addController(controller);
          },
          alignment: Alignment.center,
          fit: BoxFit.cover,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );

    return Stack(
      children: [
        background,
        Center(child: widget.child),
      ],
    );
  }
}
