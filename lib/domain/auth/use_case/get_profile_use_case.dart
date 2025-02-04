import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/auth/entity/profile_entity.dart';
import '../model/profile_model.dart';

final AutoDisposeProvider<GetProfileUseCase> getProfileUseCaseProvider =
    Provider.autoDispose<GetProfileUseCase>(
  (AutoDisposeRef<GetProfileUseCase> ref) => GetProfileUseCase(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class GetProfileUseCase {
  final AuthRepository _authRepository;
  GetProfileUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<UseCaseResult<ProfileModel>> call() async {
    final RepositoryResult<ApiResponse<ProfileEntity>> repositoryResult =
        await _authRepository.getProfile();
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<ProfileEntity>>() =>
        SuccessUseCaseResult<ProfileModel>(
          data: ProfileModel.fromEntity(
            entity: repositoryResult.data.data,
          ),
        ),
      FailureRepositoryResult<ApiResponse<ProfileEntity>>() =>
        FailureUseCaseResult<ProfileModel>(
          message: repositoryResult.messages?[0],
        )
    };
  }
}
