import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_mobile/shared/extensions/context_extension.dart';
import '../../../../shared/widgets/priority_badge.dart';
import '../task_notifier.dart';
import '../../domain/task.dart';

// タスク1件のカード表示
// → KanbanColumnから呼ばれる
// → 削除ボタンはNotifierを直接呼ぶ
class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── タイトル行 ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 削除ボタン
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: context.outline,
                    ),
                    onPressed: () => _showDeleteDialog(context, ref),
                  ),
                ),
              ],
            ),

            // ── 説明文 ────────────────────────────────────
            if (task.description != null) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 8),

            // ── 優先度・期日 ──────────────────────────────
            Row(
              children: [
                PriorityBadge(priority: task.priority),
                const Spacer(),
                if (task.dueDate != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: _dueDateColor(context, task.dueDate!),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('M/d').format(task.dueDate!),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: _dueDateColor(context, task.dueDate!),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // ── タグ ──────────────────────────────────────
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: task.tags.map((tag) {
                  final color = Color(
                    int.parse(
                      tag.color.replaceFirst('#', '0xFF'),
                    ),
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag.name,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: color,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 期日の色を返す
  // → 期日を過ぎていれば赤・今日なら橙・それ以外はグレー
  Color _dueDateColor(BuildContext context, DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (due.isBefore(today)) return Colors.red;
    if (due.isAtSameMomentAs(today)) return Colors.orange;
    return Theme.of(context).colorScheme.outline;
  }

  // 削除確認ダイアログ
  // → 誤操作防止のため確認を挟む
  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「${task.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(taskProvider.notifier).deleteTask(task.id);
    }
  }
}

// → KanbanColumnHeader でも同じ変換が必要
// → 1箇所にまとめることで修正が1箇所で済む
// → kanban_column.dart から switch 文をなくせる
extension TaskPriorityExtension on TaskPriority {
  String get lavel => switch (this) {
        TaskPriority.high => '高',
        TaskPriority.medium => '中',
        TaskPriority.low => '低',
      };

  Color get color => switch (this) {
        TaskPriority.high => Colors.red,
        TaskPriority.medium => Colors.orange,
        TaskPriority.low => Colors.green,
      };
}

extension TaskStatusExtension on TaskStatus {
  String get label => switch (this) {
        TaskStatus.todo => '未着手',
        TaskStatus.inProgress => '進行中',
        TaskStatus.done => '完了',
      };

  Color get color => switch (this) {
        TaskStatus.todo => Colors.grey,
        TaskStatus.inProgress => Colors.blue,
        TaskStatus.done => Colors.green,
      };

  IconData get icon => switch (this) {
        TaskStatus.todo => Icons.radio_button_unchecked,
        TaskStatus.inProgress => Icons.timelapse,
        TaskStatus.done => Icons.check_circle_outline,
      };
}
