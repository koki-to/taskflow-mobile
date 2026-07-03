import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/user.dart';

part 'auth_repository.g.dart';

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

// ── Provider ───────────────────────────────────────────────
// 本番用の実装をProviderで管理する
// → テスト時は ProviderContainer の overrides で
//   MockAuthRepository に差し替える
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    dio: ref.read(dioClientProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
}

// ── 実装クラス ─────────────────────────────────────────────
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  const AuthRepositoryImpl({
    required Dio dio,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _tokenStorage = tokenStorage;

  @override
  Future<LoginResponse> loginApi({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final result = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      // トークンを保存する
      // → RepositoryがTokenStorageを使う
      //   ServiceはトークンのことをRepositoryに任せる
      await _tokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      return result;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<LoginResponse> registerApi({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );
      final result = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      await _tokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      return result;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DioExceptionをAuthExceptionに変換する
  // → 上位層（Service・Notifier）がDioを知らなくて済む
  AuthException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        return const AuthException('入力内容に誤りがあります');
      case 401:
        return const AuthException('メールアドレスまたはパスワードが違います');
      case 409:
        return const AuthException('このメールアドレスは既に使用されています');
      case 500:
        return const AuthException('サーバーエラーが発生しました');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return const AuthException('タイムアウトが発生しました');
        }
        return const AuthException('ネットワークエラーが発生しました');
    }
  }
}
