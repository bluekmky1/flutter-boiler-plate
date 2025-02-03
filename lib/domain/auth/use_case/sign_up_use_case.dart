import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/data/message_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';
import '../../../data/auth/auth_repository.dart';

final AutoDisposeProvider<SignUpUseCase> signUpUseCaseProvider =
    Provider.autoDispose<SignUpUseCase>(
  (AutoDisposeRef<SignUpUseCase> ref) => SignUpUseCase(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class SignUpUseCase {
  final AuthRepository _authRepository;
  SignUpUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<UseCaseResult<void>> call({
    required String email,
    required String password,
    required String name,
    required String governanceId,
  }) async {
    final RepositoryResult<ApiResponse<MessageResponse>> repositoryResult =
        await _authRepository.signUp(
      email: email,
      password: password,
      name: name,
      governanceId: governanceId,
    );
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<MessageResponse>>() =>
        SuccessUseCaseResult<void>(
          data: repositoryResult.data.data.message,
        ),
      FailureRepositoryResult<ApiResponse<MessageResponse>>() =>
        FailureUseCaseResult<void>(
          message: repositoryResult.messages?[0],
        )
    };
  }
}
