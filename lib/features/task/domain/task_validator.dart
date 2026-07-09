import '../../../core/exceptions/task_exception.dart';

// タスクのバリデーション
// → AuthValidatorと同じ設計方針
// → Serviceから分離してテストしやすくする
class TaskValidator {
  TaskValidator._();

  static void validateTitle(String title) {
    if (title.trim().isEmpty) {
      throw const TaskException('タイトルを入力してください');
    }
    if (title.trim().length > 100) {
      throw const TaskException('タイトルは100文字以内で入力してください');
    }
  }

  static void validateDescription(String? description) {
    if (description != null && description.length > 1000) {
      throw const TaskException('説明は1000文字以内で入力してください');
    }
  }
}
