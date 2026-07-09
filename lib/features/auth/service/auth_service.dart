import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/features/auth/data/auth_repository_impl.dart';
import '../../../core/storage/token_storage.dart';
import '../data/auth_repository.dart';
import '../domain/auth_validator.dart';
import '../domain/user.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService(
    repository: ref.read(authRepositoryProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
}

class AuthService {
  final AuthRepository _repository;
  final TokenStorage _tokenStorage;

  const AuthService({
    required AuthRepository repository,
    required TokenStorage tokenStorage,
  })  : _repository = repository,
        _tokenStorage = tokenStorage;

  // ── ログイン ───────────────────────────────────────────────
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // バリデーションはValidatorに委譲する
    // → Serviceはバリデーションのロジックを知らなくていい
    AuthValidator.validateEmail(email);
    AuthValidator.validatePassword(password);

    final response = await _repository.loginApi(
      email: email,
      password: password,
    );

    return response.user;
  }

  // ── 新規登録 ───────────────────────────────────────────────
  Future<User> register({
    required String email,
    required String password,
    String? name,
  }) async {
    AuthValidator.validateEmail(email);
    AuthValidator.validatePassword(password);

    final response = await _repository.registerApi(
      email: email,
      password: password,
      name: name,
    );

    return response.user;
  }

  // ── ログアウト ─────────────────────────────────────────────
  Future<void> logout() async {
    // トークンを削除する
    await _tokenStorage.clearTokens();
  }

  // ── 自動ログイン確認 ────────────────────────────────────────
  Future<bool> hasValidToken() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null;
  }
}
