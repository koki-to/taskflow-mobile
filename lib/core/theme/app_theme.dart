import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // インスタンス化を禁止する
  // → このクラスは static メソッドだけを持つユーティリティクラスなので
  //   new AppTheme() で作られないようにプライベートコンストラクタにする
  AppTheme._();

  // ライトテーマ
  static ThemeData get light => FlexThemeData.light(
        // インディゴ・パープル系のカラースキームを使用
        // → Material 3のデフォルト（青系）より落ち着いた印象になる
        scheme: FlexScheme.indigo,

        // サーフェスの色の深さ設定
        // levelSurfacesLowScaffold = Scaffold背景は薄く・カードは少し濃い
        // → 画面の奥行き感が出てUIが見やすくなる
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,

        // カラーブレンドの強度（0〜40）
        // → 9程度が自然で見やすいバランス
        blendLevel: 9,

        subThemesData: const FlexSubThemesData(
          // onカラー（テキスト等）のブレンド強度
          blendOnLevel: 10,
          blendOnColors: false,

          // Material 3のTextThemeを使用する
          useMaterial3Typography: true,

          // Material 3のDividerにM2スタイルを適用
          // → Dividerが細くてスッキリ見える
          useM2StyleDividerInM3: true,

          // TextFieldの背景を塗りつぶす（filled: true）
          // → 入力欄が視覚的にわかりやすくなる
          inputDecoratorIsFilled: true,

          // TextFieldの枠線をアウトライン形式に
          // → Material 3の標準的なTextField見た目
          inputDecoratorBorderType: FlexInputBorderType.outline,
        ),

        // プラットフォームに合わせた適切な密度設定
        // → iOSとAndroidで適切なタップ領域になる
        visualDensity: FlexColorScheme.comfortablePlatformDensity,

        // Material 3を有効化（Flutter 3.16以降のデフォルト）
        useMaterial3: true,
      );

  // ダークテーマ
  static ThemeData get dark => FlexThemeData.dark(
        scheme: FlexScheme.indigo,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,

        // ダークモードはブレンドを強めにする
        // → 暗い背景にカラーが溶け込んで自然に見える
        blendLevel: 15,
        subThemesData: const FlexSubThemesData(
          // ダークモードはonカラーのブレンドを強めにする
          // → 暗背景でテキストが読みやすくなる
          blendOnLevel: 20,
          useMaterial3Typography: true,
          useM2StyleDividerInM3: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          alignedDropdown: true,
          navigationRailUseIndicator: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      );
}
