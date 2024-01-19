import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candy_box.freezed.dart';
part 'candy_box.g.dart';

enum CandyColor {
  blue(Colors.blue),
  red(Colors.red),
  yellow(Colors.yellow),
  green(Colors.green);

  const CandyColor(this.color);

  final Color color;
}

@freezed
class CandyBox with _$CandyBox {
  const factory CandyBox({
    @Default({}) Map<int, CandyColor> portions,
  }) = _CandyBox;

  factory CandyBox.fromJson(Map<String, dynamic> json) =>
      _$CandyBoxFromJson(json);
}
