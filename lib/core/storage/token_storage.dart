import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

// TokenStorageをProviderで管理する
// → DioClientからも AuthRepositoryからも参照できる
// → テストでモックに差し替えられる
@riverpod
TokenStorage tokenStorage(Ref ref) {
  return const TokenStorage();
}

// トークンの保存・取得・削除を一元管理するクラス
//
// なぜ AuthRepository から分離するか：
// → DioインターセプターでJWTを読む処理が必要になったとき
//   AuthRepositoryに依存すると循環参照になりかねない
// → TokenStorageを独立させることで
//   DioClientからもAuthRepositoryからも安全に参照できる
class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  const TokenStorage();

  // トークンを保存する
  // → Future.waitで2つを並行して保存することで高速化
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    debugPrint('=== saveTokens called ===');
    debugPrint('accessToken: $accessToken');
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
    debugPrint('=== saveTokens done ===');
  }

  // アクセストークンを取得する
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  // リフレッシュトークンを取得する
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  // トークンを全て削除する（ログアウト時）
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
