import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// freezedでイミュータブルなUserモデルを定義する
//
// なぜfreezedを使うか：
// → 手書きでは == / hashCode / copyWith / toString を
//   全て実装する必要があり100行以上になる
// → freezedが自動生成することでモデルクラスが数行で書ける
// → final で全フィールドが不変になりバグが減る
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? name, // null許容（未設定の場合がある）
  }) = _User;

  // fromJson：APIレスポンスのMapをUserに変換する
  // → json_serializableが自動生成する
  // → 手書きのfromJsonは型変換ミスが起きやすいので自動生成が安全
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
