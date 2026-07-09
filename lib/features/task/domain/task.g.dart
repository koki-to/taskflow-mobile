// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'TODO',
  TaskStatus.inProgress: 'IN_PROGRESS',
  TaskStatus.done: 'DONE',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'LOW',
  TaskPriority.medium: 'MEDIUM',
  TaskPriority.high: 'HIGH',
};

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'userId': instance.userId,
    };
