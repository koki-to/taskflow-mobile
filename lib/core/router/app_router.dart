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

@riverpod
GoRouter appRouter(Ref ref) {
  // AuthStateを監視する
  // → isAuthenticated が変化したときに
  //   GoRouterがredirectを再実行する
  final authState = ref.watch(authProvider);

  return GoRouter(
    // 起動時はスプラッシュ画面から始める
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthenticated = authState.isAuthenticated;

      if (location == AppRoutes.splash) return null;

      // 認証不要なページ
      // → ログイン画面・新規登録画面は未ログインでも表示できる
      final isPublicPage =
          location == AppRoutes.login || location == AppRoutes.register;

      // 未ログイン → ログイン画面へ
      if (!isAuthenticated && !isPublicPage) {
        return AppRoutes.login;
      }

      // ログイン済みでログイン画面 → カンバンへ
      if (isAuthenticated && isPublicPage) {
        return AppRoutes.kanban;
      }

      return null;
    },
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
