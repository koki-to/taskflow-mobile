import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/token_storage.dart';

part 'dio_client.g.dart';

// DioをProviderで管理する
// → アプリ全体で1つのDioインスタンスを使い回す
// → 全Repositoryはこれをrefで受け取る
@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      // TODO: --dart-define で環境ごとに切り替える（Day5）
      baseUrl: 'http://localhost:3001',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // JWTインターセプターを追加する
  // → 全APIリクエストに自動でAuthorizationヘッダーを付与する
  // → Day3でリフレッシュ処理も追加する
  dio.interceptors.add(
    AuthInterceptor(ref.read(tokenStorageProvider)),
  );

  return dio;
}

// JWT自動付与インターセプター
//
// なぜインターセプターを使うか：
// → 全APIリクエストに毎回手動でヘッダーを書くのは重複コード
// → インターセプターで一元管理することで
//   全Repositoryで自動的にJWTが付与される
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  const AuthInterceptor(this._tokenStorage);

  // リクエスト送信前にJWTを自動付与する
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
