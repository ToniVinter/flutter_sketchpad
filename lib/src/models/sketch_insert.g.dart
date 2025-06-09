// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sketch_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SketchInsertImpl _$$SketchInsertImplFromJson(Map<String, dynamic> json) =>
    _$SketchInsertImpl(
      id: json['id'] as String,
      sketchId: json['sketchId'] as String?,
      sectionId: json['sectionId'] as String,
      points: const OffsetListConverter().fromJson(json['points'] as List),
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      type: $enumDecodeNullable(_$SketchInsertTypeEnumMap, json['type']) ??
          SketchInsertType.drawing,
      text: json['text'] as String?,
      textPosition: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['textPosition'], const OffsetConverter().fromJson),
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SketchInsertImplToJson(_$SketchInsertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sketchId': instance.sketchId,
      'sectionId': instance.sectionId,
      'points': const OffsetListConverter().toJson(instance.points),
      'color': const ColorConverter().toJson(instance.color),
      'strokeWidth': instance.strokeWidth,
      'type': _$SketchInsertTypeEnumMap[instance.type]!,
      'text': instance.text,
      'textPosition': _$JsonConverterToJson<Map<String, dynamic>, Offset>(
          instance.textPosition, const OffsetConverter().toJson),
      'fontSize': instance.fontSize,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SketchInsertTypeEnumMap = {
  SketchInsertType.drawing: 'drawing',
  SketchInsertType.text: 'text',
  SketchInsertType.eraser: 'eraser',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
