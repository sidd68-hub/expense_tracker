import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_providers.dart';

part 'sign_up_controller.g.dart';

@riverpod
class SignUpController extends _$SignUpController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUpWithEmail(email: email, password: password),
    );
  }
}
