// アプリの設定値を一元管理するクラス
//
// なぜ AppConfig クラスにまとめるか：
// → --dart-define の値を直接 String.fromEnvironment() で
//   各ファイルに書くとタイポのリスクがある
// → 1箇所にまとめることで変更が1箇所で済む
// → デフォルト値を設定することで
//   --dart-define を渡し忘れたときでも動作する
class AppConfig {
  AppConfig._();

  // APIのベースURL
  // → flutter run --dart-define=API_BASE_URL=http://xxx で上書きできる
  // → デフォルトはローカル開発環境のURL
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  // 開発環境かどうか
  // → kDebugMode よりも明示的に環境を判定できる
  static const isProduction = String.fromEnvironment(
        'ENVIRONMENT',
        defaultValue: 'development',
      ) ==
      'production';
}
