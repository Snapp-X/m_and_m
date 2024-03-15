// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candy_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CandyBoxImpl _$$CandyBoxImplFromJson(Map<String, dynamic> json) =>
    _$CandyBoxImpl(
      portions: (json['portions'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(int.parse(k), $enumDecode(_$CandyColorEnumMap, e)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$CandyBoxImplToJson(_$CandyBoxImpl instance) =>
    <String, dynamic>{
      'portions': instance.portions
          .map((k, e) => MapEntry(k.toString(), _$CandyColorEnumMap[e]!)),
    };

const _$CandyColorEnumMap = {
  CandyColor.blue: 'blue',
  CandyColor.yellow: 'yellow',
  CandyColor.green: 'green',
  CandyColor.red: 'red',
};
