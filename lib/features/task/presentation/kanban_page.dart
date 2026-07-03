import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../features/auth/presentation/auth_notifier.dart';

class KanbanPage extends ConsumerWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // selectでuserのnameだけを監視する
    // → AuthState全体を監視すると
    //   isLoadingの変化でもこのWidgetが再ビルドされてしまう
    // → nameだけを監視することで不要な再ビルドを防ぐ
    final userName = ref.watch(
      authProvider.select((s) => s.user?.name),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ログアウト',
            onPressed: () {
              // Notifierのlogoutを呼ぶだけ
              // → トークン削除→状態リセット→GoRouterがリダイレクト
              //   という流れが全て自動で動く
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userName != null)
              Text(
                'こんにちは、$userName さん',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 16),
            const Text('カンバンボード（Day6で実装）'),
          ],
        ),
      ),
    );
  }
}
