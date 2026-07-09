import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

// タスクのステータス
// → バックエンドのenumと値を合わせる
// → @JsonValue でJSONの文字列と対応させる
enum TaskStatus {
  @JsonValue('TODO')
  todo,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('DONE')
  done,
}

// タスクの優先度
enum TaskPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
}

// Taskモデル
//
// なぜfreezedを使うか：
// → 全フィールドがfinalで不変になる
// → copyWith・==・hashCode・toStringが自動生成される
// → fromJson・toJsonがjson_serializableと組み合わせて自動生成される
// → 手書きだと100行以上になるコードが数行で書ける
@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Tag> tags,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

// タグモデル（タスクに紐づく）
@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String name,
    required String color,
    required String userId,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
