import 'package:flutter/material.dart';
import 'package:taskflow_mobile/features/task/presentation/widget/task_card.dart';
import '../../features/task/domain/task.dart';

// 優先度バッジ
// → 複数の画面で使い回すためshared/widgetsに置く
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    // 拡張メソッドを使ってスッキリ書く
    final label = priority.lavel;
    final color = priority.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
