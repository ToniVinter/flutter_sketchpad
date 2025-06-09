// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sketch_insert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SketchInsert _$SketchInsertFromJson(Map<String, dynamic> json) {
  return _SketchInsert.fromJson(json);
}

/// @nodoc
mixin _$SketchInsert {
  /// Unique insert ID
  String get id => throw _privateConstructorUsedError;

  /// ID of the sketch this insert belongs to
  String? get sketchId => throw _privateConstructorUsedError;

  /// ID of the section within the content
  String get sectionId => throw _privateConstructorUsedError;
  @OffsetListConverter()
  List<Offset> get points => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get color => throw _privateConstructorUsedError;
  double get strokeWidth => throw _privateConstructorUsedError;
  SketchInsertType get type => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  @OffsetConverter()
  Offset? get textPosition => throw _privateConstructorUsedError;
  double? get fontSize => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SketchInsert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SketchInsertCopyWith<SketchInsert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SketchInsertCopyWith<$Res> {
  factory $SketchInsertCopyWith(
          SketchInsert value, $Res Function(SketchInsert) then) =
      _$SketchInsertCopyWithImpl<$Res, SketchInsert>;
  @useResult
  $Res call(
      {String id,
      String? sketchId,
      String sectionId,
      @OffsetListConverter() List<Offset> points,
      @ColorConverter() Color color,
      double strokeWidth,
      SketchInsertType type,
      String? text,
      @OffsetConverter() Offset? textPosition,
      double? fontSize,
      DateTime? createdAt});
}

/// @nodoc
class _$SketchInsertCopyWithImpl<$Res, $Val extends SketchInsert>
    implements $SketchInsertCopyWith<$Res> {
  _$SketchInsertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sketchId = freezed,
    Object? sectionId = null,
    Object? points = null,
    Object? color = null,
    Object? strokeWidth = null,
    Object? type = null,
    Object? text = freezed,
    Object? textPosition = freezed,
    Object? fontSize = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sketchId: freezed == sketchId
          ? _value.sketchId
          : sketchId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      strokeWidth: null == strokeWidth
          ? _value.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SketchInsertType,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textPosition: freezed == textPosition
          ? _value.textPosition
          : textPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      fontSize: freezed == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SketchInsertImplCopyWith<$Res>
    implements $SketchInsertCopyWith<$Res> {
  factory _$$SketchInsertImplCopyWith(
          _$SketchInsertImpl value, $Res Function(_$SketchInsertImpl) then) =
      __$$SketchInsertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? sketchId,
      String sectionId,
      @OffsetListConverter() List<Offset> points,
      @ColorConverter() Color color,
      double strokeWidth,
      SketchInsertType type,
      String? text,
      @OffsetConverter() Offset? textPosition,
      double? fontSize,
      DateTime? createdAt});
}

/// @nodoc
class __$$SketchInsertImplCopyWithImpl<$Res>
    extends _$SketchInsertCopyWithImpl<$Res, _$SketchInsertImpl>
    implements _$$SketchInsertImplCopyWith<$Res> {
  __$$SketchInsertImplCopyWithImpl(
      _$SketchInsertImpl _value, $Res Function(_$SketchInsertImpl) _then)
      : super(_value, _then);

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sketchId = freezed,
    Object? sectionId = null,
    Object? points = null,
    Object? color = null,
    Object? strokeWidth = null,
    Object? type = null,
    Object? text = freezed,
    Object? textPosition = freezed,
    Object? fontSize = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SketchInsertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sketchId: freezed == sketchId
          ? _value.sketchId
          : sketchId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      strokeWidth: null == strokeWidth
          ? _value.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SketchInsertType,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textPosition: freezed == textPosition
          ? _value.textPosition
          : textPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      fontSize: freezed == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SketchInsertImpl implements _SketchInsert {
  const _$SketchInsertImpl(
      {required this.id,
      this.sketchId,
      required this.sectionId,
      @OffsetListConverter() required final List<Offset> points,
      @ColorConverter() required this.color,
      required this.strokeWidth,
      this.type = SketchInsertType.drawing,
      this.text,
      @OffsetConverter() this.textPosition,
      this.fontSize,
      this.createdAt})
      : _points = points;

  factory _$SketchInsertImpl.fromJson(Map<String, dynamic> json) =>
      _$$SketchInsertImplFromJson(json);

  /// Unique insert ID
  @override
  final String id;

  /// ID of the sketch this insert belongs to
  @override
  final String? sketchId;

  /// ID of the section within the content
  @override
  final String sectionId;
  final List<Offset> _points;
  @override
  @OffsetListConverter()
  List<Offset> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  @ColorConverter()
  final Color color;
  @override
  final double strokeWidth;
  @override
  @JsonKey()
  final SketchInsertType type;
  @override
  final String? text;
  @override
  @OffsetConverter()
  final Offset? textPosition;
  @override
  final double? fontSize;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SketchInsert(id: $id, sketchId: $sketchId, sectionId: $sectionId, points: $points, color: $color, strokeWidth: $strokeWidth, type: $type, text: $text, textPosition: $textPosition, fontSize: $fontSize, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SketchInsertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sketchId, sketchId) ||
                other.sketchId == sketchId) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.textPosition, textPosition) ||
                other.textPosition == textPosition) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sketchId,
      sectionId,
      const DeepCollectionEquality().hash(_points),
      color,
      strokeWidth,
      type,
      text,
      textPosition,
      fontSize,
      createdAt);

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SketchInsertImplCopyWith<_$SketchInsertImpl> get copyWith =>
      __$$SketchInsertImplCopyWithImpl<_$SketchInsertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SketchInsertImplToJson(
      this,
    );
  }
}

abstract class _SketchInsert implements SketchInsert {
  const factory _SketchInsert(
      {required final String id,
      final String? sketchId,
      required final String sectionId,
      @OffsetListConverter() required final List<Offset> points,
      @ColorConverter() required final Color color,
      required final double strokeWidth,
      final SketchInsertType type,
      final String? text,
      @OffsetConverter() final Offset? textPosition,
      final double? fontSize,
      final DateTime? createdAt}) = _$SketchInsertImpl;

  factory _SketchInsert.fromJson(Map<String, dynamic> json) =
      _$SketchInsertImpl.fromJson;

  /// Unique insert ID
  @override
  String get id;

  /// ID of the sketch this insert belongs to
  @override
  String? get sketchId;

  /// ID of the section within the content
  @override
  String get sectionId;
  @override
  @OffsetListConverter()
  List<Offset> get points;
  @override
  @ColorConverter()
  Color get color;
  @override
  double get strokeWidth;
  @override
  SketchInsertType get type;
  @override
  String? get text;
  @override
  @OffsetConverter()
  Offset? get textPosition;
  @override
  double? get fontSize;
  @override
  DateTime? get createdAt;

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SketchInsertImplCopyWith<_$SketchInsertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
