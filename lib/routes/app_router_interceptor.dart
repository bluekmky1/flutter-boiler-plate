import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth/entity/auth_token_entity.dart';
import '../service/app/app_service.dart';
import '../service/app/app_state.dart';
import '../service/storage/storage_key.dart';
import '../service/storage/storage_service.dart';
import 'routes.dart';
// import '../service/app/app_service.dart';
// import '../service/app/app_state.dart';
// import 'routes.dart';

// redirect 여부 및 redirect location 를 결정하는 역할을 수행합니다.
class AppRouterInterceptor {
  // ignore: unused_field
  final Ref _ref;

  const AppRouterInterceptor({
    required Ref<Object?> ref,
  }) : _ref = ref;

  // 라우트의 이동마다 호출됩니다.
  // ignore: prefer_expression_function_bodies
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final StorageService storageService = _ref.read(storageServiceProvider);
    final String? accessToken =
        await storageService.getString(key: StorageKey.accessToken);

    final String? refreshToken =
        await storageService.getString(key: StorageKey.refreshToken);

    // 토큰이 없다면 로그인 페이지로 이동합니다.
    if (accessToken == null || refreshToken == null) {
      return Routes.signIn.name;
    }

    // 토큰이 있다면 로그인 상태를 업데이트 합니다.
    await _ref.read(appServiceProvider.notifier).signIn(
          authTokens: AuthTokenEntity(
              accessToken: accessToken, refreshToken: refreshToken),
        );

    // 로그인 상태를 확인합니다.
    final bool isSignedIn = _ref
        .read(appServiceProvider.select((AppState value) => value.isSignedIn));

    // 로그인 상태가 아니라면 로그인 페이지로 이동합니다.
    if (!isSignedIn) {
      // sign in 으로 가야만 하는 상태입니다.
      if (state.fullPath?.startsWith(Routes.auth.name) == false) {
        return Routes.signIn.name;
      }
    } else {
      // 현재 위치가 아직도 auth 관련 페이지에 있다면
      // 즉시 가족 구성원 화면으로 리다이렉트 해줍니다.
      if (state.fullPath != null &&
          state.fullPath!.startsWith(Routes.auth.name)) {
        return Routes.home.name;
      }
    }

    return null;
  }
}
