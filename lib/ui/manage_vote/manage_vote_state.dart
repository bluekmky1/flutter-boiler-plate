import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/loading_status.dart';

class ManageVoteState extends Equatable {
  final LoadingStatus getVoteMetadataLoadingStatus;
  final LoadingStatus createVoteLoadingStatus;
  final LoadingStatus resetVoteLoadingStatus;
  final bool isVoteActive;

  final String voteName;
  final String voteDateTime;
  final String voteDescription;

  final String guideImagePath;
  final XFile guideImage;

  const ManageVoteState({
    required this.getVoteMetadataLoadingStatus,
    required this.createVoteLoadingStatus,
    required this.resetVoteLoadingStatus,
    required this.isVoteActive,
    required this.voteName,
    required this.voteDateTime,
    required this.voteDescription,
    required this.guideImagePath,
    required this.guideImage,
  });

  ManageVoteState.init()
      : getVoteMetadataLoadingStatus = LoadingStatus.none,
        createVoteLoadingStatus = LoadingStatus.none,
        resetVoteLoadingStatus = LoadingStatus.none,
        isVoteActive = false,
        voteName = '',
        voteDateTime = '',
        voteDescription = '',
        guideImagePath = '',
        guideImage = XFile('');

  ManageVoteState copyWith({
    LoadingStatus? getVoteMetadataLoadingStatus,
    LoadingStatus? createVoteLoadingStatus,
    LoadingStatus? resetVoteLoadingStatus,
    bool? isVoteActive,
    String? voteName,
    String? voteDateTime,
    String? voteDescription,
    String? guideImagePath,
    XFile? guideImage,
  }) =>
      ManageVoteState(
        getVoteMetadataLoadingStatus:
            getVoteMetadataLoadingStatus ?? this.getVoteMetadataLoadingStatus,
        createVoteLoadingStatus:
            createVoteLoadingStatus ?? this.createVoteLoadingStatus,
        resetVoteLoadingStatus:
            resetVoteLoadingStatus ?? this.resetVoteLoadingStatus,
        isVoteActive: isVoteActive ?? this.isVoteActive,
        voteName: voteName ?? this.voteName,
        voteDateTime: voteDateTime ?? this.voteDateTime,
        voteDescription: voteDescription ?? this.voteDescription,
        guideImagePath: guideImagePath ?? this.guideImagePath,
        guideImage: guideImage ?? this.guideImage,
      );

  @override
  List<Object> get props => <Object>[
        getVoteMetadataLoadingStatus,
        createVoteLoadingStatus,
        resetVoteLoadingStatus,
        isVoteActive,
        voteName,
        voteDateTime,
        voteDescription,
        guideImagePath,
        guideImage,
      ];

  bool get isLoading =>
      getVoteMetadataLoadingStatus == LoadingStatus.loading ||
      getVoteMetadataLoadingStatus == LoadingStatus.none ||
      createVoteLoadingStatus == LoadingStatus.loading ||
      resetVoteLoadingStatus == LoadingStatus.loading;
}
