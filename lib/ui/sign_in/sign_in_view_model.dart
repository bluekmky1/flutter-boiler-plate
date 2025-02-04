import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/use_case/use_case_result.dart';
import '../../core/loading_status.dart';
import '../../data/auth/entity/auth_token_entity.dart';
import '../../data/auth/entity/sign_in_entity.dart';
import '../../domain/auth/use_case/sign_in_use_case.dart';
import '../../service/app/app_service.dart';
import 'sign_in_state.dart';

final AutoDisposeStateNotifierProvider<SignInViewModel, SignInState>
    signInViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<SignInState> ref) => SignInViewModel(
    state: const SignInState.init(),
    signInUseCase: ref.watch(signInUseCaseProvider),
    appService: ref.watch(appServiceProvider.notifier),
  ),
);

class SignInViewModel extends StateNotifier<SignInState> {
  final SignInUseCase _signInUseCase;
  final AppService _appService;
  SignInViewModel({
    required SignInState state,
    required SignInUseCase signInUseCase,
    required AppService appService,
  })  : _signInUseCase = signInUseCase,
        _appService = appService,
        super(state);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      signInLoadingStatus: LoadingStatus.loading,
    );

    final UseCaseResult<SignInEntity> result = await _signInUseCase(
      email: email,
      password: password,
    );

    switch (result) {
      case SuccessUseCaseResult<SignInEntity>():
        await _appService.signIn(
          authTokens: AuthTokenEntity(
            accessToken: result.data.accessToken,
            refreshToken: result.data.refreshToken,
          ),
          role: result.data.role,
        );
        state = state.copyWith(
          signInLoadingStatus: LoadingStatus.success,
        );
      case FailureUseCaseResult<SignInEntity>():
        state = state.copyWith(
          signInLoadingStatus: LoadingStatus.error,
          emailErrorMessage: '이메일 또는 비밀번호가 올바르지 않습니다.',
          passwordErrorMessage: '이메일 또는 비밀번호가 올바르지 않습니다.',
        );
    }
  }
}
