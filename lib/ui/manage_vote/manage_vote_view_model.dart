import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/common/use_case/use_case_result.dart';
import '../../core/loading_status.dart';
import '../../domain/vote/model/vote_metadata_model.dart';
import '../../domain/vote/use_case/create_vote_use_case.dart';
import '../../domain/vote/use_case/get_vote_use_case.dart';
import '../../domain/vote/use_case/reset_vote_use_case.dart';
import 'manage_vote_state.dart';

final AutoDisposeStateNotifierProvider<ManageVoteViewModel, ManageVoteState>
    manageVoteViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<ManageVoteState> ref) => ManageVoteViewModel(
    state: ManageVoteState.init(),
    getVoteMetadataUseCase: ref.read(getVoteUseCaseProvider),
    resetVoteUseCase: ref.read(resetVoteUseCaseProvider),
    createVoteUseCase: ref.read(createVoteUseCaseProvider),
  ),
);

class ManageVoteViewModel extends StateNotifier<ManageVoteState> {
  final GetVoteUseCase _getVoteMetadataUseCase;
  final CreateVoteUseCase _createVoteUseCase;
  final ResetVoteUseCase _resetVoteUseCase;
  ManageVoteViewModel({
    required ManageVoteState state,
    required GetVoteUseCase getVoteMetadataUseCase,
    required CreateVoteUseCase createVoteUseCase,
    required ResetVoteUseCase resetVoteUseCase,
  })  : _getVoteMetadataUseCase = getVoteMetadataUseCase,
        _createVoteUseCase = createVoteUseCase,
        _resetVoteUseCase = resetVoteUseCase,
        super(state);

  Future<void> getVoteMetadata() async {
    state = state.copyWith(
      getVoteMetadataLoadingStatus: LoadingStatus.loading,
    );

    final UseCaseResult<VoteMetadataModel> result =
        await _getVoteMetadataUseCase();

    switch (result) {
      case SuccessUseCaseResult<VoteMetadataModel>():
        state = state.copyWith(
          getVoteMetadataLoadingStatus: LoadingStatus.success,
          isVoteActive: true,
          voteName: result.data.voteName,
          voteDateTime: result.data.voteDateTime,
          voteDescription: result.data.voteDescription,
          guideImagePath: result.data.fileUrl,
        );
      case FailureUseCaseResult<VoteMetadataModel>():
        if (result.message == '선거 메타데이터 조회에 실패했습니다.') {
          state = state.copyWith(
            getVoteMetadataLoadingStatus: LoadingStatus.success,
            isVoteActive: false,
          );
        } else {
          state = state.copyWith(
            getVoteMetadataLoadingStatus: LoadingStatus.error,
          );
        }
    }
  }

  Future<void> resetVote() async {
    state = state.copyWith(
      resetVoteLoadingStatus: LoadingStatus.loading,
    );

    final UseCaseResult<void> result = await _resetVoteUseCase();

    switch (result) {
      case SuccessUseCaseResult<void>():
        state = state.copyWith(
          resetVoteLoadingStatus: LoadingStatus.success,
          isVoteActive: false,
        );
      case FailureUseCaseResult<void>():
        state = state.copyWith(
          resetVoteLoadingStatus: LoadingStatus.error,
        );
    }
  }

  Future<void> createVote({
    required String voteDateTime,
    required String voteDescription,
    required String voteName,
  }) async {
    state = state.copyWith(
      createVoteLoadingStatus: LoadingStatus.loading,
    );

    if (state.guideImage.path.isEmpty) {
      state = state.copyWith(
        createVoteLoadingStatus: LoadingStatus.error,
      );
      return;
    }

    final Uint8List image = await state.guideImage.readAsBytes();

    final UseCaseResult<void> result = await _createVoteUseCase(
      image: image,
      voteDateTime: voteDateTime,
      voteDescription: voteDescription,
      voteName: voteName,
    );

    switch (result) {
      case SuccessUseCaseResult<void>():
        state = state.copyWith(
          createVoteLoadingStatus: LoadingStatus.success,
        );
      case FailureUseCaseResult<void>():
        state = state.copyWith(
          createVoteLoadingStatus: LoadingStatus.error,
        );
    }
  }

  void setGuideImage({required XFile image}) {
    state = state.copyWith(
      guideImage: image,
    );
  }
}
