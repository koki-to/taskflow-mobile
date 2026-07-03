// アプリ全体の基底例外クラス
//
// なぜ基底クラスを作るか：
// → catch (e) で AppException をキャッチすれば
//   全種類の例外をまとめて処理できる
// → 種類別の例外（AuthException・NetworkException）は
//   これを継承して作る
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}
