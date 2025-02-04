import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';
import '../../../data/vote/entity/vote_entity.dart';
import '../../../data/vote/vote_repository.dart';
import '../model/vote_metadata_model.dart';

final AutoDisposeProvider<GetVoteUseCase> getVoteUseCaseProvider =
    Provider.autoDispose<GetVoteUseCase>(
  (AutoDisposeRef<GetVoteUseCase> ref) => GetVoteUseCase(
    voteRepository: ref.read(voteRepositoryProvider),
  ),
);

class GetVoteUseCase {
  final VoteRepository _voteRepository;
  GetVoteUseCase({
    required VoteRepository voteRepository,
  }) : _voteRepository = voteRepository;

  Future<UseCaseResult<VoteMetadataModel>> call() async {
    final RepositoryResult<ApiResponse<VoteEntity>> repositoryResult =
        await _voteRepository.getVoteMetadata();
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<VoteEntity>>() =>
        SuccessUseCaseResult<VoteMetadataModel>(
          data: VoteMetadataModel.fromEntity(
            entity: repositoryResult.data.data,
          ),
        ),
      FailureRepositoryResult<ApiResponse<VoteEntity>>() =>
        const FailureUseCaseResult<VoteMetadataModel>(
          message: '선거 메타데이터 조회에 실패했습니다.',
        )
    };
  }
}
