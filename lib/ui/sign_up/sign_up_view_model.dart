import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/use_case/use_case_result.dart';
import '../../core/loading_status.dart';
import '../../domain/auth/use_case/sign_up_use_case.dart';
import 'sign_up_state.dart';

final AutoDisposeStateNotifierProvider<SignUpViewModel, SignUpState>
    signUpViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<SignUpState> ref) => SignUpViewModel(
    state: const SignUpState.init(),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
  ),
);

class SignUpViewModel extends StateNotifier<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpViewModel({
    required SignUpState state,
    required SignUpUseCase signUpUseCase,
  })  : _signUpUseCase = signUpUseCase,
        super(state);

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String governanceId,
  }) async {
    state = state.copyWith(
      signUpLoadingStatus: LoadingStatus.loading,
    );

    final UseCaseResult<void> result = await _signUpUseCase(
      email: email,
      password: password,
      name: name,
      governanceId: governanceId,
    );

    switch (result) {
      case SuccessUseCaseResult<void>():
        state = state.copyWith(
          signUpLoadingStatus: LoadingStatus.success,
        );
      case FailureUseCaseResult<void>():
        state = state.copyWith(
          signUpLoadingStatus: LoadingStatus.error,
        );
    }
  }
}
