import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/task/presentation/kanban_page.dart';

part 'app_router.g.dart';

class AppRoutes {
  AppRoutes._();
  static const login = '/login';
  static const kanban = '/kanban';
}

@riverpod
GoRouter appRouter(Ref ref) {
  // AuthStateを監視する
  // → isAuthenticated が変化したときに
  //   GoRouterがredirectを再実行する
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.kanban,
    redirect: (context, state) {
      // まだ自動ログイン確認中は何もしない
      // → checkAuthStatus()が完了するまでリダイレクトしない
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final isAuthenticated = authState.isAuthenticated;
      final isLoginPage = state.matchedLocation == AppRoutes.login;

      // 未ログイン → ログイン画面へ
      if (!isAuthenticated && !isLoginPage) {
        return AppRoutes.login;
      }

      // ログイン済みでログイン画面 → カンバンへ
      if (isAuthenticated && isLoginPage) {
        return AppRoutes.kanban;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.kanban,
        builder: (context, state) => const KanbanPage(),
      ),
    ],
  );
}
