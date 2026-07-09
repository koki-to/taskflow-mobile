import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskflow_mobile/features/task/domain/task.dart';
import 'package:taskflow_mobile/features/task/presentation/task_notifier.dart';
import 'package:taskflow_mobile/features/task/presentation/widget/kanban_column.dart';
import 'package:taskflow_mobile/features/task/presentation/widget/task_card.dart';
import '../../../features/auth/presentation/auth_notifier.dart';

class KanbanPage extends ConsumerWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(
      taskProvider.select((s) => s.tasks),
    );
    final isLoading = ref.watch(
      taskProvider.select((s) => s.isLoading),
    );
    final errorMessage = ref.watch(
      taskProvider.select((s) => s.errorMessage),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ログアウト',
            onPressed: () {
              // Notifierのlogoutを呼ぶだけ
              // → トークン削除→状態リセット→GoRouterがリダイレクト
              //   という流れが全て自動で動く
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _buildBody(
        context: context,
        ref: ref,
        tasks: tasks,
        isLoading: isLoading,
        errorMessage: errorMessage,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Day7でタスク作成フォームに置き換える
          ref.read(taskProvider.notifier).createTask(
                title: 'テストタスク ${tasks.length + 1}',
                priority: TaskPriority.medium,
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required List<Task> tasks,
    required bool isLoading,
    required String? errorMessage,
  }) {
    // エラー状態
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.read(taskProvider.notifier).loadTasks(),
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    // ローディング状態
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // カンバンボード（横スクロール）
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: TaskStatus.values.map((status) {
        final columnTasks = tasks.where((t) => t.status == status).toList();

        return Expanded(
          child: _KanbanColumn(
            status: status,
            tasks: columnTasks,
            ref: ref,
          ),
        );
      }).toList(),
    );
  }
}

// カンバンの1カラム
class _KanbanColumn extends StatelessWidget {
  final TaskStatus status;
  final List<Task> tasks;
  final WidgetRef ref;

  const _KanbanColumn({
    required this.status,
    required this.tasks,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // カラムヘッダー
          KanbanColumnHeader(
            status: status,
            taskCount: tasks.length,
          ),

          const Divider(height: 1),

          // タスクリスト
          Expanded(
            child: tasks.isEmpty
                ? const KanbanEmptyColumn()
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: tasks[index]);
                    },
                  ),
          ),

          // ステータス変更ボタン群
          // → D&Dの代わりにボタンでステータスを変更する
          _StatusChangeButtons(
            status: status,
            ref: ref,
            tasks: tasks,
          ),
        ],
      ),
    );
  }
}

// ステータス変更ボタン（D&Dの代替）
// → 現場では小規模アプリではD&Dより
//   ボタンでのステータス変更の方がシンプルで保守しやすい
class _StatusChangeButtons extends StatelessWidget {
  final TaskStatus status;
  final List<Task> tasks;
  final WidgetRef ref;

  const _StatusChangeButtons({
    required this.status,
    required this.tasks,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // Day8でタスク詳細画面でステータス変更を実装する
  }
}
