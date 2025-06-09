// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sketch_insert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SketchInsert {
  /// Unique insert ID
  String get id;

  /// ID of the sketch this insert belongs to
  String? get sketchId;

  /// ID of the section within the content
  String get sectionId;
  @OffsetListConverter()
  List<Offset> get points;
  @ColorConverter()
  Color get color;
  double get strokeWidth;
  SketchInsertType get type;
  String? get text;
  @OffsetConverter()
  Offset? get textPosition;
  double? get fontSize;
  DateTime? get createdAt;

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SketchInsertCopyWith<SketchInsert> get copyWith =>
      _$SketchInsertCopyWithImpl<SketchInsert>(
          this as SketchInsert, _$identity);

  /// Serializes this SketchInsert to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SketchInsert &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sketchId, sketchId) ||
                other.sketchId == sketchId) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            const DeepCollectionEquality().equals(other.points, points) &&
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
      const DeepCollectionEquality().hash(points),
      color,
      strokeWidth,
      type,
      text,
      textPosition,
      fontSize,
      createdAt);

  @override
  String toString() {
    return 'SketchInsert(id: $id, sketchId: $sketchId, sectionId: $sectionId, points: $points, color: $color, strokeWidth: $strokeWidth, type: $type, text: $text, textPosition: $textPosition, fontSize: $fontSize, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $SketchInsertCopyWith<$Res> {
  factory $SketchInsertCopyWith(
          SketchInsert value, $Res Function(SketchInsert) _then) =
      _$SketchInsertCopyWithImpl;
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
class _$SketchInsertCopyWithImpl<$Res> implements $SketchInsertCopyWith<$Res> {
  _$SketchInsertCopyWithImpl(this._self, this._then);

  final SketchInsert _self;
  final $Res Function(SketchInsert) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sketchId: freezed == sketchId
          ? _self.sketchId
          : sketchId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: null == sectionId
          ? _self.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SketchInsertType,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textPosition: freezed == textPosition
          ? _self.textPosition
          : textPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      fontSize: freezed == fontSize
          ? _self.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SketchInsert implements SketchInsert {
  const _SketchInsert(
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
  factory _SketchInsert.fromJson(Map<String, dynamic> json) =>
      _$SketchInsertFromJson(json);

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

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SketchInsertCopyWith<_SketchInsert> get copyWith =>
      __$SketchInsertCopyWithImpl<_SketchInsert>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SketchInsertToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SketchInsert &&
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

  @override
  String toString() {
    return 'SketchInsert(id: $id, sketchId: $sketchId, sectionId: $sectionId, points: $points, color: $color, strokeWidth: $strokeWidth, type: $type, text: $text, textPosition: $textPosition, fontSize: $fontSize, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$SketchInsertCopyWith<$Res>
    implements $SketchInsertCopyWith<$Res> {
  factory _$SketchInsertCopyWith(
          _SketchInsert value, $Res Function(_SketchInsert) _then) =
      __$SketchInsertCopyWithImpl;
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
class __$SketchInsertCopyWithImpl<$Res>
    implements _$SketchInsertCopyWith<$Res> {
  __$SketchInsertCopyWithImpl(this._self, this._then);

  final _SketchInsert _self;
  final $Res Function(_SketchInsert) _then;

  /// Create a copy of SketchInsert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_SketchInsert(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sketchId: freezed == sketchId
          ? _self.sketchId
          : sketchId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: null == sectionId
          ? _self.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SketchInsertType,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textPosition: freezed == textPosition
          ? _self.textPosition
          : textPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      fontSize: freezed == fontSize
          ? _self.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
