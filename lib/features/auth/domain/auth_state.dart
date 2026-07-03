import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'auth_state.freezed.dart';

// 認証画面の状態を表すfreezedクラス
//
// なぜ AuthStatus（enum）ではなく freezed にするか：
// → enumはisLoading・errorMessage・userなどの
//   追加フィールドを持てない
// → freezedのcopyWithで部分的な状態更新が簡単にできる
// → UIに必要な全状態をひとまとめに管理できる
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    // 認証済みかどうか
    @Default(false) bool isAuthenticated,

    // API呼び出し中かどうか
    // → trueの間はボタンを無効化してローディングを表示する
    @Default(false) bool isLoading,

    // エラーメッセージ
    // → nullのときはエラーなし
    String? errorMessage,

    // ログイン済みユーザー情報
    // → nullのときは未ログイン
    User? user,
  }) = _AuthState;

  // initial：初期状態を作るファクトリ
  // → Notifierのbuild()でこれを返す
  factory AuthState.initial() => const AuthState();
}
