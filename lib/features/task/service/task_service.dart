import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/features/task/data/task_repository.dart';
import '../data/task_repository_impl.dart';
import '../domain/task.dart';
import '../domain/task_validator.dart';

part 'task_service.g.dart';

@riverpod
TaskService taskService(Ref ref) {
  return TaskService(
    repository: ref.read(taskRepositoryProvider),
  );
}

// Service：ビジネスロジックを担当する
// → バリデーション・Repositoryの呼び出し
// → ViewもNotifierも知らない
class TaskService {
  final TaskRepository _repository;

  const TaskService({required TaskRepository repository})
      : _repository = repository;

  // ── タスク一覧取得 ──────────────────────────────────────
  Future<List<Task>> getTasks() async {
    return _repository.getTasks();
  }

  // ── タスク作成 ──────────────────────────────────────────
  Future<Task> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
  }) async {
    // バリデーションはValidatorに委譲する
    TaskValidator.validateTitle(title);
    TaskValidator.validateDescription(description);

    return _repository.createTask(
      CreateTaskInput(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      ),
    );
  }

  // ── タスク更新 ──────────────────────────────────────────
  Future<Task> updateTask({
    required String id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
  }) async {
    if (title != null) TaskValidator.validateTitle(title);
    if (description != null) {
      TaskValidator.validateDescription(description);
    }

    return _repository.updateTask(
      id,
      UpdateTaskInput(
        title: title,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
      ),
    );
  }

  // ── タスク削除 ──────────────────────────────────────────
  Future<void> deleteTask(String id) async {
    return _repository.deleteTask(id);
  }

  // ── ステータス変更（カンバンのD&D用）──────────────────────
  // → D&DではステータスだけをPATCHする
  // → updateTask を呼んでもいいが
  //   カンバン専用のメソッドとして分けることで
  //   意図が明確になる
  Future<Task> updateTaskStatus({
    required String id,
    required TaskStatus status,
  }) async {
    return _repository.updateTaskStatus(id, status);
  }
}
