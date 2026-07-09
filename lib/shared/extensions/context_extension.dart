import 'package:flutter/material.dart';

// BuildContext の拡張メソッド
//
// なぜ拡張メソッドにするか：
// → Theme.of(context).colorScheme を毎回書くのは冗長
// → context.colorScheme と書くだけでスッキリする
// → 全Widgetで共通して使えるためshared/extensionsに置く
extension BuildContextExtension on BuildContext {
  // ── テーマ関連 ─────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ── よく使うColorSchemeの値 ────────────────────────────
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get secondary => colorScheme.secondary;
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;
  Color get error => colorScheme.error;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;

  // ── 画面サイズ ─────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}
