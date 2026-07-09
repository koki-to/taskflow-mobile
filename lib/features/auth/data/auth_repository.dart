import '../domain/user.dart';

// ── レスポンス型 ────────────────────────────────────────────
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}

// ── 抽象クラス（インターフェース）──────────────────────────
//
// なぜ抽象クラスを作るか：
// → テストで MockAuthRepository に差し替えられる
// → DioやSecureStorageの詳細を上位層に隠せる
// → 将来FirebaseAuthに切り替えるときも
//   この抽象クラスを実装するだけでいい
abstract class AuthRepository {
  Future<LoginResponse> loginApi({
    required String email,
    required String password,
  });

  Future<LoginResponse> registerApi({
    required String email,
    required String password,
    String? name,
  });
}
