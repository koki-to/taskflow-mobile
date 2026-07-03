import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // appRouterProvider を watch する
    // → authNotifierProvider の isAuthenticated が変化すると
    //   GoRouterが再生成されてredirectが再実行される
    // → これがないとログイン・ログアウトで画面遷移しない
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // GoRouterを渡す
      // → routerConfig に GoRouter を渡すことで
      //   MaterialApp.router が GoRouter の
      //   routerDelegate・routeInformationParser を使う
      routerConfig: router,
    );
  }
}
