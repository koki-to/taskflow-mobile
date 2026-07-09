// ── Provider ──────────────────────────────────────────────
//
// なぜProviderをImplファイルに置くか：
// → 抽象クラスのファイルはインターフェースの定義だけにする
// → 実装の詳細（どのクラスを使うか）はImplファイルが知っていればいい
// → テストでは overrides でMockに差し替える
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/core/exceptions/task_exception.dart';
import 'package:taskflow_mobile/core/network/dio_client.dart';
import 'package:taskflow_mobile/features/task/data/task_repository.dart';
import 'package:taskflow_mobile/features/task/domain/task.dart';

part 'task_repository_impl.g.dart';

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepositoryImpl(
    dio: ref.read(dioClientProvider),
  );
}

// ── 実装クラス ─────────────────────────────────────────────
class TaskRepositoryImpl implements TaskRepository {
  final Dio _dio;

  const TaskRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      final tasks = response.data['tasks'] as List;
      return tasks
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Task> createTask(CreateTaskInput input) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: input.toJson(),
      );
      return Task.fromJson(
        response.data['task'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Task> updateTask(String id, UpdateTaskInput input) async {
    try {
      final response = await _dio.patch(
        '/tasks/$id',
        data: input.toJson(),
      );
      return Task.fromJson(
        response.data['task'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Task> updateTaskStatus(
    String id,
    TaskStatus status,
  ) async {
    return updateTask(
      id,
      UpdateTaskInput(status: status),
    );
  }

  // DioExceptionをTaskExceptionに変換する
  // → 上位層（Service・Notifier）がDioを知らなくて済む
  TaskException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        return const TaskException('入力内容に誤りがあります');
      case 401:
        return const TaskException('認証が必要です');
      case 403:
        return const TaskException('この操作の権限がありません');
      case 404:
        return const TaskException('タスクが見つかりません');
      case 500:
        return const TaskException('サーバーエラーが発生しました');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return const TaskException('タイムアウトが発生しました');
        }
        return const TaskException('ネットワークエラーが発生しました');
    }
  }
}
