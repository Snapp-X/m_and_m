// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candy_box.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CandyBox _$CandyBoxFromJson(Map<String, dynamic> json) {
  return _CandyBox.fromJson(json);
}

/// @nodoc
mixin _$CandyBox {
  Map<int, CandyColor> get portions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CandyBoxCopyWith<CandyBox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandyBoxCopyWith<$Res> {
  factory $CandyBoxCopyWith(CandyBox value, $Res Function(CandyBox) then) =
      _$CandyBoxCopyWithImpl<$Res, CandyBox>;
  @useResult
  $Res call({Map<int, CandyColor> portions});
}

/// @nodoc
class _$CandyBoxCopyWithImpl<$Res, $Val extends CandyBox>
    implements $CandyBoxCopyWith<$Res> {
  _$CandyBoxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? portions = null,
  }) {
    return _then(_value.copyWith(
      portions: null == portions
          ? _value.portions
          : portions // ignore: cast_nullable_to_non_nullable
              as Map<int, CandyColor>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandyBoxImplCopyWith<$Res>
    implements $CandyBoxCopyWith<$Res> {
  factory _$$CandyBoxImplCopyWith(
          _$CandyBoxImpl value, $Res Function(_$CandyBoxImpl) then) =
      __$$CandyBoxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<int, CandyColor> portions});
}

/// @nodoc
class __$$CandyBoxImplCopyWithImpl<$Res>
    extends _$CandyBoxCopyWithImpl<$Res, _$CandyBoxImpl>
    implements _$$CandyBoxImplCopyWith<$Res> {
  __$$CandyBoxImplCopyWithImpl(
      _$CandyBoxImpl _value, $Res Function(_$CandyBoxImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? portions = null,
  }) {
    return _then(_$CandyBoxImpl(
      portions: null == portions
          ? _value._portions
          : portions // ignore: cast_nullable_to_non_nullable
              as Map<int, CandyColor>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CandyBoxImpl implements _CandyBox {
  const _$CandyBoxImpl({final Map<int, CandyColor> portions = const {}})
      : _portions = portions;

  factory _$CandyBoxImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandyBoxImplFromJson(json);

  final Map<int, CandyColor> _portions;
  @override
  @JsonKey()
  Map<int, CandyColor> get portions {
    if (_portions is EqualUnmodifiableMapView) return _portions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_portions);
  }

  @override
  String toString() {
    return 'CandyBox(portions: $portions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandyBoxImpl &&
            const DeepCollectionEquality().equals(other._portions, _portions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_portions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CandyBoxImplCopyWith<_$CandyBoxImpl> get copyWith =>
      __$$CandyBoxImplCopyWithImpl<_$CandyBoxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CandyBoxImplToJson(
      this,
    );
  }
}

abstract class _CandyBox implements CandyBox {
  const factory _CandyBox({final Map<int, CandyColor> portions}) =
      _$CandyBoxImpl;

  factory _CandyBox.fromJson(Map<String, dynamic> json) =
      _$CandyBoxImpl.fromJson;

  @override
  Map<int, CandyColor> get portions;
  @override
  @JsonKey(ignore: true)
  _$$CandyBoxImplCopyWith<_$CandyBoxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
