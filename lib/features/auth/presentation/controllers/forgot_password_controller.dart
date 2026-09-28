import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_providers.dart';

part 'forgot_password_controller.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendPasswordResetEmail(email),
    );
  }
}
