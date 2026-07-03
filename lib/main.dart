import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskflow_mobile/app.dart';

void main() async {
  // Flutterのバインディングを初期化する
  // → main()でasyncを使う場合や
  //   runApp()より前にプラットフォームのAPIを呼ぶ場合に必須
  //   flutter_secure_storage・hive_ce などの初期化で必要になる
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScopeでアプリ全体を囲む
    // → Riverpodの全Providerはこの中でしか使えない
    //   テスト時にProviderContainerで上書きできる
    const ProviderScope(
      child: App(),
    ),
  );
}
