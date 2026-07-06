import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow_mobile/core/config/app_config.dart';
import '../storage/token_storage.dart';

part 'dio_client.g.dart';

// DioをProviderで管理する
// → アプリ全体で1つのDioインスタンスを使い回す
// → 全Repositoryはこれをrefで受け取る
@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      // ハードコードをやめてAppConfigから読む
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // JWTインターセプターを追加する
  // → 全APIリクエストに自動でAuthorizationヘッダーを付与する
  // → Day3でリフレッシュ処理も追加する
  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: ref.read(tokenStorageProvider),
      dio: dio,
    ),
  );

  // 開発環境のみログを出力する
  // → 本番環境でAPIのリクエスト・レスポンスをログに残すのは
  //   セキュリティリスクになる
  if (!AppConfig.isProduction) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // print()ではなくdebugPrintを使う
        // → analysis_options.yamlでavoid_printを設定しているため
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );
  }

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
  final Dio _dio;

  // リフレッシュ処理が重複して走らないようにするフラグ
  // → 複数のAPIが同時に401を返したとき
  //   リフレッシュが何度も走るのを防ぐ
  bool _isRefreshing = false;

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  // ── リクエスト時：JWTを自動付与 ───────────────────────────
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

  // ── 401エラー時：トークンをリフレッシュして再リクエスト ───
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401以外のエラーはそのまま流す
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // 既にリフレッシュ処理中の場合はそのままエラーを流す
    // → 無限ループを防ぐ
    if (_isRefreshing) {
      handler.next(err);
      return;
    }

    _isRefreshing = true;

    try {
      // ① リフレッシュトークンを取得する
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        // リフレッシュトークンがない → ログアウト状態にする
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      // ② リフレッシュAPIを叩く
      // → インターセプターを経由しないように
      //   新しいDioインスタンスを使う
      //   （同じDioを使うと無限ループになる）
      final refreshDio = Dio(
        BaseOptions(baseUrl: AppConfig.apiBaseUrl),
      );

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      // ③ 新しいトークンを保存する
      final newAccessToken = response.data['accessToken'] as String;
      final newRefreshToken = response.data['refreshToken'] as String;

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // ④ 失敗したリクエストを新しいトークンで再実行する
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _dio.fetch(
        err.requestOptions,
      );
      handler.resolve(retryResponse);
    } catch (e) {
      // リフレッシュ失敗 → トークンを削除してログアウト
      await _tokenStorage.clearTokens();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
