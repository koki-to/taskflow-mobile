import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/features/auth/presentation/register_page.dart';
import 'package:taskflow_mobile/features/auth/presentation/splash_page.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/task/presentation/kanban_page.dart';

part 'app_router.g.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const kanban = '/kanban';
  static const register = '/register';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // AuthNotifier を直接取得する
  // → ref.read を使って GoRouter の生成は1回だけにする
  // → AuthNotifier は Listenable なので
  //   refreshListenable に直接渡せる
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    // 起動時はスプラッシュ画面から始める
    initialLocation: AppRoutes.splash,

    // AuthNotifier を refreshListenable に渡す
    // → state が変化して notifyListeners() が呼ばれるたびに
    //   redirect が自動で再実行される
    refreshListenable: authNotifier,

    redirect: ((context, state) {
      final authState = authNotifier.state;
      final location = state.matchedLocation;
      final isInitialized = authState.isInitialized;
      final isAuthenticated = authState.isAuthenticated;

      // 初期化完了前はスプラッシュのまま待つ
      // → checkAuthStatus() が完了するまで遷移しない
      if (!isInitialized) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // 認証不要ページの定義
      final isPublicPage =
          location == AppRoutes.login || location == AppRoutes.register;

      // 初期化完了後にスプラッシュにいる場合は遷移する
      if (location == AppRoutes.splash) {
        return isAuthenticated ? AppRoutes.kanban : AppRoutes.login;
      }

      // 未ログイン → ログイン画面へ
      if (!isAuthenticated && !isPublicPage) {
        return AppRoutes.login;
      }

      // ログイン済みで認証不要ページ → カンバンへ
      if (isAuthenticated && isPublicPage) {
        return AppRoutes.kanban;
      }

      return null;
    }),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.kanban,
        builder: (context, state) => const KanbanPage(),
      ),
    ],
  );
}
