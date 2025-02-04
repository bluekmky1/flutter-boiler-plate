import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/data/message_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';

import '../../../data/vote/vote_repository.dart';

final AutoDisposeProvider<ResetVoteUseCase> resetVoteUseCaseProvider =
    Provider.autoDispose<ResetVoteUseCase>(
  (AutoDisposeRef<ResetVoteUseCase> ref) => ResetVoteUseCase(
    voteRepository: ref.read(voteRepositoryProvider),
  ),
);

class ResetVoteUseCase {
  final VoteRepository _voteRepository;
  ResetVoteUseCase({
    required VoteRepository voteRepository,
  }) : _voteRepository = voteRepository;

  Future<UseCaseResult<void>> call() async {
    final RepositoryResult<ApiResponse<MessageResponse>> repositoryResult =
        await _voteRepository.resetVote();
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<MessageResponse>>() =>
        const SuccessUseCaseResult<void>(
          data: null,
        ),
      FailureRepositoryResult<ApiResponse<MessageResponse>>() =>
        const FailureUseCaseResult<void>(
          message: '선거 초기화에 실패했습니다.',
        )
    };
  }
}
