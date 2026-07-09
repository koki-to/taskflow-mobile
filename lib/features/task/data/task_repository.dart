import '../domain/task.dart';

// ── リクエスト型 ───────────────────────────────────────────
class CreateTaskInput {
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;

  const CreateTaskInput({
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.dueDate,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'priority': priority.name.toUpperCase(),
        if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      };
}

class UpdateTaskInput {
  final String? title;
  final String? description;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? dueDate;

  const UpdateTaskInput({
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (status != null) 'status': status!.name.toUpperCase(),
        if (priority != null) 'priority': priority!.name.toUpperCase(),
        if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      };
}

// ── 抽象クラス（インターフェース） ──────────────────────────
//
// なぜ抽象クラスとImplを分けるか：
// → このファイルを見るだけで
//   「TaskRepositoryは何ができるか」が一目でわかる
// → 実装の詳細（DioやAPIのパス）を知らなくていい
// → テストでMockに差し替えるときにこのファイルだけimportすればいい
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> createTask(CreateTaskInput input);
  Future<Task> updateTask(String id, UpdateTaskInput input);
  Future<void> deleteTask(String id);
  Future<Task> updateTaskStatus(String id, TaskStatus status);
}
