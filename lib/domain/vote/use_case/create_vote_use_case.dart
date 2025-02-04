import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/data/api_response.dart';
import '../../../core/common/data/message_response.dart';
import '../../../core/common/repository/repository_result.dart';
import '../../../core/common/use_case/use_case_result.dart';
import '../../../data/vote/vote_repository.dart';

final AutoDisposeProvider<CreateVoteUseCase> createVoteUseCaseProvider =
    Provider.autoDispose<CreateVoteUseCase>(
  (AutoDisposeRef<CreateVoteUseCase> ref) => CreateVoteUseCase(
    voteRepository: ref.read(voteRepositoryProvider),
  ),
);

class CreateVoteUseCase {
  final VoteRepository _voteRepository;
  CreateVoteUseCase({
    required VoteRepository voteRepository,
  }) : _voteRepository = voteRepository;

  Future<UseCaseResult<void>> call({
    required String voteName,
    required String voteDateTime,
    required String voteDescription,
    required Uint8List image,
  }) async {
    final RepositoryResult<ApiResponse<MessageResponse>> repositoryResult =
        await _voteRepository.createVote(
      voteName: voteName,
      voteDateTime: voteDateTime,
      voteDescription: voteDescription,
      image: image,
    );
    return switch (repositoryResult) {
      SuccessRepositoryResult<ApiResponse<MessageResponse>>() =>
        const SuccessUseCaseResult<void>(
          data: null,
        ),
      FailureRepositoryResult<ApiResponse<MessageResponse>>() =>
        const FailureUseCaseResult<void>(
          message: '선거 생성에 실패했습니다.',
        )
    };
  }
}
