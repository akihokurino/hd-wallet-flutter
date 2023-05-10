// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nft_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NftState {
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NftStateCopyWith<NftState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NftStateCopyWith<$Res> {
  factory $NftStateCopyWith(NftState value, $Res Function(NftState) then) =
      _$NftStateCopyWithImpl<$Res, NftState>;
  @useResult
  $Res call({bool isLoading});
}

/// @nodoc
class _$NftStateCopyWithImpl<$Res, $Val extends NftState>
    implements $NftStateCopyWith<$Res> {
  _$NftStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NftStateCopyWith<$Res> implements $NftStateCopyWith<$Res> {
  factory _$$_NftStateCopyWith(
          _$_NftState value, $Res Function(_$_NftState) then) =
      __$$_NftStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading});
}

/// @nodoc
class __$$_NftStateCopyWithImpl<$Res>
    extends _$NftStateCopyWithImpl<$Res, _$_NftState>
    implements _$$_NftStateCopyWith<$Res> {
  __$$_NftStateCopyWithImpl(
      _$_NftState _value, $Res Function(_$_NftState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
  }) {
    return _then(_$_NftState(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NftState implements _NftState {
  const _$_NftState({this.isLoading = false});

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'NftState(isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NftState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NftStateCopyWith<_$_NftState> get copyWith =>
      __$$_NftStateCopyWithImpl<_$_NftState>(this, _$identity);
}

abstract class _NftState implements NftState {
  const factory _NftState({final bool isLoading}) = _$_NftState;

  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_NftStateCopyWith<_$_NftState> get copyWith =>
      throw _privateConstructorUsedError;
}
