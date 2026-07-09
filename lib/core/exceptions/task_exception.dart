import 'app_exception.dart';

// タスク操作系の例外
// → AuthExceptionと同じ設計方針
// → core/exceptions/ に置くことで全featureから参照できる
class TaskException extends AppException {
  const TaskException(super.message);
}
