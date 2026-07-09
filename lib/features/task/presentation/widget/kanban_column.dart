import 'package:flutter/material.dart';
import 'package:taskflow_mobile/features/task/presentation/widget/task_card.dart';
import '../../domain/task.dart';

// カンバンの1カラム（TODO・進行中・完了）
// → AppFlowyBoardのカラムヘッダーとして使う
class KanbanColumnHeader extends StatelessWidget {
  final TaskStatus status;
  final int taskCount;

  const KanbanColumnHeader({
    super.key,
    required this.status,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    final label = status.label;
    final color = status.color;
    final icon = status.icon;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$taskCount',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// タスクが0件のときの空状態表示
class KanbanEmptyColumn extends StatelessWidget {
  const KanbanEmptyColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'タスクなし',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ),
    );
  }
}
