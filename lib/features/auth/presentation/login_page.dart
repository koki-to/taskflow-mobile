import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskflow_mobile/features/auth/presentation/auth_notifier.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);

    // AuthStateを監視する
    // → isLoading・errorMessage・isAuthenticated の変化で
    //   自動的にUIが再ビルドされる
    final authState = ref.watch(authProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── ロゴ・タイトル ───────────────────────────
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),

                Text(
                  'TaskFlow',
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'タスクを、シンプルに管理する',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // ── エラーメッセージ ─────────────────────────
                // → authState.errorMessage が null でなければ表示
                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.onErrorContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── メールアドレス入力欄 ─────────────────────
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  // ローディング中は入力を無効化する
                  enabled: !authState.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // ── パスワード入力欄 ─────────────────────────
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible.value,
                  autofillHints: const [AutofillHints.password],
                  enabled: !authState.isLoading,
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── ログインボタン ───────────────────────────
                FilledButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          // Notifierのloginを呼ぶだけ
                          // → バリデーション・API・状態更新は
                          //   全てNotifier → Service → Repositoryが行う
                          ref.read(authProvider.notifier).login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        },
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('ログイン'),
                ),
                const SizedBox(height: 16),

                // ── 新規登録リンク ───────────────────────────
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          // Day3で新規登録画面への遷移を追加
                        },
                  child: const Text('アカウントをお持ちでない方はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
