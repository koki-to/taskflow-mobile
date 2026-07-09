import 'package:freezed_annotation/freezed_annotation.dart';
import 'task.dart';

part 'task_state.freezed.dart';

// タスク画面全体の状態
//
// なぜカンバンのカラムごとに分けないか：
// → 1つのStateで全タスクを持ち
//   UIで status ごとにフィルタリングする方が
//   状態の更新がシンプルになる
// → カンバンのD&Dでステータスを変更するとき
//   1つのtasks リストを更新するだけで済む
@freezed
abstract class TaskState with _$TaskState {
  const factory TaskState({
    // 全タスクのリスト
    @Default([]) List<Task> tasks,

    // ローディング状態
    @Default(false) bool isLoading,

    // エラーメッセージ
    String? errorMessage,

    // タスク作成・更新中の状態
    // → カンバン全体のisLoadingとは別に管理する
    //   カード操作中にカンバン全体がローディングになるのを防ぐ
    @Default(false) bool isMutating,
  }) = _TaskState;

  factory TaskState.initial() => const TaskState();
}
