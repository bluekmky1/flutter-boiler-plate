import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/auth/entity/sign_in_entity.dart';

final AutoDisposeProvider<SignInUseCase> signInUseCaseProvider =
    Provider.autoDispose<SignInUseCase>(
  (AutoDisposeRef<SignInUseCase> ref) => SignInUseCase(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class SignInUseCase {
  final AuthRepository _authRepository;
  SignInUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<UseCaseResult<SignInEntity>> call({
    required String email,
    required String password,
  }) async {
    final RepositoryResult<ApiResponse<SignInEntity>> repositoryResult =
        await _authRepository.signIn(
      email: email,
      password: password,
    );
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<SignInEntity>>() =>
        SuccessUseCaseResult<SignInEntity>(
          data: repositoryResult.data.data,
        ),
      FailureRepositoryResult<ApiResponse<SignInEntity>>() =>
        FailureUseCaseResult<SignInEntity>(
          message: repositoryResult.messages?[0],
        )
    };
  }
}
