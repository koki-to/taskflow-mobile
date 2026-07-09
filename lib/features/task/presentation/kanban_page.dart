import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskflow_mobile/features/task/domain/task.dart';
import 'package:taskflow_mobile/features/task/presentation/task_notifier.dart';
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

    // タスクが0件の状態
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'タスクがありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '右下の + ボタンでタスクを追加できます',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    // タスク一覧（ステータスごとに表示）
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatusSection(
          context: context,
          ref: ref,
          title: '📋 未着手',
          tasks: tasks
              .where(
                (t) => t.status == TaskStatus.todo,
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildStatusSection(
          context: context,
          ref: ref,
          title: '🔄 進行中',
          tasks: tasks
              .where(
                (t) => t.status == TaskStatus.inProgress,
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildStatusSection(
          context: context,
          ref: ref,
          title: '✅ 完了',
          tasks: tasks
              .where(
                (t) => t.status == TaskStatus.done,
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSection({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required List<Task> tasks,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tasks.length}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'タスクなし',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...tasks.map(
            (task) => _buildTaskCard(
              context: context,
              ref: ref,
              task: task,
            ),
          ),
      ],
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required WidgetRef ref,
    required Task task,
  }) {
    final priorityColor = switch (task.priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.orange,
      TaskPriority.low => Colors.green,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(task.title),
        subtitle: task.description != null
            ? Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Theme.of(context).colorScheme.error,
          onPressed: () {
            ref.read(taskProvider.notifier).deleteTask(task.id);
          },
        ),
      ),
    );
  }
}
