import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch ではなく ref.read を使う
    // → GoRouter を1回だけ生成して保持する
    // → ref.watch を使うと authProvider の変化で
    //   GoRouter が再生成されてスプラッシュに戻る
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
