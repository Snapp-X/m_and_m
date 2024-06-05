import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

const _animationLayerName = "Timeline 1";

final _resultTransitionRiveProvider = FutureProvider<RiveFile>((ref) async {
  final data = await rootBundle.load('assets/rive/result_transition.riv');

  final riveFile = RiveFile.import(data);

  return riveFile;
});

class ResultBackgroundAnimation extends ConsumerStatefulWidget {
  const ResultBackgroundAnimation({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResultBackgroundAnimationState();
}

class _ResultBackgroundAnimationState
    extends ConsumerState<ResultBackgroundAnimation> {
  @override
  Widget build(BuildContext context) {
    final lampFile = ref.watch(_resultTransitionRiveProvider);
    final background = lampFile.maybeWhen(
      data: (data) {
        return RiveAnimation.direct(
          data,
          alignment: Alignment.center,
          fit: BoxFit.cover,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );

    if (widget.child == null) return background;

    return Stack(
      children: [
        background,
        Center(child: widget.child),
      ],
    );
  }
}
