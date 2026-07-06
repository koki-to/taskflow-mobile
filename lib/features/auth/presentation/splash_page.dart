import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskflow_mobile/core/router/app_router.dart';
import 'auth_notifier.dart';

// 起動時に認証状態を確認する画面
//
// なぜSplashPageを作るか：
// → main()でProviderContainerを使って非同期処理をすると
//   Providerが再構築されたときにRefが破棄されてエラーになる
// → ProviderScope内のWidgetから呼ぶことで
//   Providerのライフサイクルと一致させる
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // initStateで非同期処理を呼ぶ
    // → Future.microtaskでbuild()完了後に実行する
    //   buildの中でstateを変更するとエラーになるため
    Future.microtask(() => _checkAuth());
  }

  Future<void> _checkAuth() async {
    // ref.mounted で Widget が生きているか確認してから実行
    // → 画面が離脱されていたら処理をしない
    if (!mounted) return;

    await ref.read(authProvider.notifier).checkAuthStatus();

    // checkAuthStatus完了後に手動で遷移する
    // → GoRouterのredirectだけに頼ると
    //   タイミングによって画面が切り替わらないことがある
    if (!mounted) return;

    final isAuthenticated = ref.read(authProvider).isAuthenticated;

    if (isAuthenticated) {
      context.go(AppRoutes.kanban);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'TaskFlow',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
