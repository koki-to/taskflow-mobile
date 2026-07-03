import '../../../core/exceptions/auth_exception.dart';

// バリデーションだけを担当するクラス
//
// なぜServiceから分離するか：
// → バリデーションだけの単体テストが書ける
// → 新規登録・プロフィール編集など
//   複数のServiceで同じバリデーションを使い回せる
// → Serviceがスッキリする
class AuthValidator {
  // インスタンス化不要なユーティリティクラスのため
  // コンストラクタをプライベートにする
  AuthValidator._();

  static void validateEmail(String email) {
    if (email.trim().isEmpty) {
      throw const AuthException('メールアドレスを入力してください');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      throw const AuthException('正しいメールアドレスを入力してください');
    }
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw const AuthException('パスワードを入力してください');
    }
    if (password.length < 8) {
      throw const AuthException('パスワードは8文字以上で入力してください');
    }
  }
}
