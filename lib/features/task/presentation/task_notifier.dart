import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/exceptions/task_exception.dart';
import '../domain/task.dart';
import '../domain/task_state.dart';
import '../service/task_service.dart';

part 'task_notifier.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  TaskState build() {
    // Provider生成時に自動でタスクを読み込む
    // → KanbanPageが表示されたときに自動でAPIを叩く
    Future.microtask(() => loadTasks());
    return TaskState.initial();
  }

  // ── タスク一覧取得 ──────────────────────────────────────
  Future<void> loadTasks() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final tasks = await ref.read(taskServiceProvider).getTasks();

      if (!ref.mounted) return;

      state = state.copyWith(
        isLoading: false,
        tasks: tasks,
      );
    } on TaskException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    }
  }

  // ── タスク作成 ──────────────────────────────────────────
  Future<void> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
  }) async {
    state = state.copyWith(isMutating: true);

    try {
      final task = await ref.read(taskServiceProvider).createTask(
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
          );

      if (!ref.mounted) return;

      // 作成したタスクをリストの先頭に追加する
      state = state.copyWith(
        isMutating: false,
        tasks: [task, ...state.tasks],
      );
    } on TaskException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isMutating: false,
        errorMessage: e.message,
      );
    }
  }

  // ── タスク削除 ──────────────────────────────────────────
  Future<void> deleteTask(String id) async {
    state = state.copyWith(isMutating: true);

    try {
      await ref.read(taskServiceProvider).deleteTask(id);

      if (!ref.mounted) return;

      // 削除したタスクをリストから除外する
      // → APIの再取得をしないので高速に反映される
      state = state.copyWith(
        isMutating: false,
        tasks: state.tasks.where((t) => t.id != id).toList(),
      );
    } on TaskException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isMutating: false,
        errorMessage: e.message,
      );
    }
  }

  // ── ステータス変更（カンバンのD&D用） ──────────────────
  //
  // なぜ楽観的更新をするか：
  // → D&DでカードをドロップしてからAPIが返るまで
  //   カードが元の位置に戻って見えるとUXが悪い
  // → 先にUIを更新してからAPIを叩く
  // → APIが失敗したら元の状態に戻す
  Future<void> updateTaskStatus({
    required String id,
    required TaskStatus status,
  }) async {
    // ① 現在の状態を保存する（失敗時に戻すため）
    final previousTasks = state.tasks;

    // ② 楽観的更新：先にUIを更新する
    state = state.copyWith(
      tasks: state.tasks.map((t) {
        return t.id == id ? t.copyWith(status: status) : t;
      }).toList(),
    );

    try {
      // ③ APIを叩く
      await ref
          .read(taskServiceProvider)
          .updateTaskStatus(id: id, status: status);
    } on TaskException catch (e) {
      if (!ref.mounted) return;

      // ④ 失敗したら元の状態に戻す
      state = state.copyWith(
        tasks: previousTasks,
        errorMessage: e.message,
      );
    }
  }
}
