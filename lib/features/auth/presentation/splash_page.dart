import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    debugPrint('=== checkAuthStatus 開始 ===');

    // checkAuthStatus を実行する
    // → 完了後の画面遷移は app.dart の ref.listen が処理する
    // → ここで context.go() を呼ばない
    //   → SplashPage は認証確認だけを担当する
    //   → 画面遷移の責務は app.dart に分離する
    await ref.read(authProvider.notifier).checkAuthStatus();
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
