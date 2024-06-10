import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/catch_game/presentation/page/candy_controller.dart';
import 'package:m_and_m/src/features/catch_game/presentation/provider/catch_game_const.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class CacheGameController extends ChangeNotifier {
  CacheGameController({
    required this.vsync,
    required this.screenSizeProvider,
    required this.onCandyCatch,
  });

  final Random random = Random();
  Timer? timer;

  final TickerProvider vsync;

  final Size Function() screenSizeProvider;
  final ValueChanged<CandyColor> onCandyCatch;

  /// Bag position notifier
  /// The bag position is the center of the bag widget
  final ValueNotifier<Offset> bagPosition = ValueNotifier(Offset.zero);

  /// Candy controllers notifier
  /// The candy controllers are the candies that are falling down
  final ValueNotifier<List<CandyController>> candyControllers =
      ValueNotifier([]);

  void startGame() {
    timer?.cancel();

    timer = Timer.periodic(
      candyGenerateInterval,
      (timer) {
        final List<int> availableRowPositions = List.generate(
          candyRowCount(screenSizeProvider()),
          (index) => index,
        )
            .where(
              (position) => !candyControllers.value.any(
                (controller) => controller.rowPosition == position,
              ),
            )
            .toList();

        candyControllers.value = [
          ...candyControllers.value,
          CandyController(
            vsync: vsync,
            color: CandyColor.values[timer.tick % CandyColor.values.length],
            rowPosition: availableRowPositions[
                random.nextInt(availableRowPositions.length)],
            autoStart: true,
            duration: candyFallDuration,
            onFallAnimationCompleted: _removeCandyController,
            onPositionChanged: _onCandyPositionChanged,
          ),
        ];
      },
    );
  }

  void finishGame() {
    timer?.cancel();

    for (var controller in candyControllers.value) {
      controller.startFadeOut();
    }
  }

  void updateBagPosition(Offset newPosition, Size screenSize) {
    if (newPosition.dx < bagHalfSize ||
        newPosition.dx > screenSize.width - bagHalfSize) {
      return;
    }

    final effectivePosition = Offset(
      newPosition.dx,
      screenSize.height - bagWidgetHeight,
    );

    bagPosition.value = effectivePosition - const Offset(bagHalfSize, 0);
  }

  void _onCandyPositionChanged(String candyId) {
    final controller = candyControllers.value.firstWhereOrNull(
      (controller) => controller.id == candyId,
    );

    if (controller == null) return;

    final screenSize = screenSizeProvider();
    final rowCount = candyRowCount(screenSize);
    final outerPadding = (screenSize.width - rowCount * candyRowWidth) / 2;

    final bagOffset = bagPosition.value;

    /// The collector rect is the rect where the candies are collected
    final collectorRect = _collectorRect(bagOffset);

    final candyDx = controller.dxPosition(
      outerPadding,
      candyOuterPadding,
      candySize,
    );

    final candyDy = controller.dyPosition(screenSize.height, candySize);

    final candyRect = Rect.fromLTWH(
      candyDx,
      candyDy,
      candySize,
      candySize,
    );

    if (candyRect.overlaps(collectorRect)) {
      onCandyCatch(controller.color);

      controller.startFadeOut();
    }
  }

  void _removeCandyController(String candyId) {
    final removedController = candyControllers.value.firstWhereOrNull(
      (controller) => controller.id == candyId,
    );

    if (removedController == null) return;

    candyControllers.value = candyControllers.value
        .where((controller) => controller.id != candyId)
        .toList();

    removedController.dispose();
  }

  Rect _collectorRect(Offset position) {
    final collectorCenter = position +
        const Offset(
          (bagWidgetWidth - collectorBagWidth) / 2,
          bagWidgetHeight - collectorBagHeight,
        );

    return Rect.fromLTWH(
      collectorCenter.dx,
      collectorCenter.dy,
      collectorBagWidth,
      collectorBagHeight,
    );
  }

  int candyRowCount(Size screenSize) => screenSize.width ~/ candyRowWidth;

  @override
  void dispose() {
    timer?.cancel();

    for (var controller in candyControllers.value) {
      controller.dispose();
    }

    bagPosition.dispose();
    candyControllers.dispose();

    super.dispose();
  }
}
