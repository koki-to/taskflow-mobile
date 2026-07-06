import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/core/exceptions/auth_exception.dart';
import '../domain/auth_state.dart';
import '../service/auth_service.dart';

part 'auth_notifier.g.dart';

// ViewModel：状態管理と画面ロジックだけを担当する
//
// なぜNotifierはServiceを呼ぶだけにするか：
// → バリデーションやエラー変換をNotifierに書くと
//   テストしにくくなる（UIに依存した処理が混在するため）
// → Serviceにビジネスロジックを任せることで
//   NotifierはisLoading・errorMessageなどの
//   UI状態の管理だけに集中できる
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  // ── ログイン ───────────────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // ① ローディング開始・エラーリセット
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // ② Serviceを呼ぶだけ
      // → バリデーション・API・トークン保存は全てServiceが行う
      final user = await ref
          .read(authServiceProvider)
          .login(email: email, password: password);

      // ③ 成功 → 認証済み状態に更新
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
    } on AuthException catch (e) {
      // ④ 失敗 → エラーメッセージを状態に反映
      // → ViewはerrorMessageを監視して表示するだけ
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    }
  }

  // ── 新規登録 ───────────────────────────────────────────────
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final user = await ref.read(authServiceProvider).register(
            email: email,
            password: password,
            name: name,
          );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    }
  }

  // ── ログアウト ─────────────────────────────────────────────
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await ref.read(authServiceProvider).logout();

      // 初期状態に戻す
      state = AuthState.initial();
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    }
  }

  // ── 自動ログイン確認 ────────────────────────────────────────
  // → アプリ起動時にmain.dartから呼ぶ（Day3で追加）
  Future<void> checkAuthStatus() async {
    final hasToken = await ref.read(authServiceProvider).hasValidToken();
    // ref.mounted で Provider が生きているか確認する
    // → 非同期処理の完了前に Provider が破棄されていた場合
    //   state への書き込みを防ぐ
    if (!ref.mounted) return;

    state = state.copyWith(
      isAuthenticated: hasToken,
    );
  }
}
