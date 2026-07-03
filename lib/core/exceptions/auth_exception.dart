import 'app_exception.dart';

// 認証系の例外
// → ログイン失敗・バリデーションエラーなど
// → auth_service.dart の中に書いていたものを分離
//
// なぜ別ファイルにするか：
// → Notifier・Service・Repositoryのどこからでも
//   importできる共通の例外クラスにするため
// → core/exceptions/ に置くことで
//   全featureから参照できる
class AuthException extends AppException {
  const AuthException(super.message);
}
