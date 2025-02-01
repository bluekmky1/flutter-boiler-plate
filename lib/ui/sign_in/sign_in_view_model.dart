import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/use_case/use_case_result.dart';
import '../../core/loading_status.dart';
import '../../data/auth/entity/auth_token_entity.dart';
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

    final UseCaseResult<AuthTokenEntity> result = await _signInUseCase(
      email: email,
      password: password,
    );

    switch (result) {
      case SuccessUseCaseResult<AuthTokenEntity>():
        await _appService.signIn(
          authTokens: result.data,
        );
        state = state.copyWith(
          signInLoadingStatus: LoadingStatus.success,
        );
      case FailureUseCaseResult<AuthTokenEntity>():
        state = state.copyWith(
          signInLoadingStatus: LoadingStatus.error,
        );
    }
  }
}
