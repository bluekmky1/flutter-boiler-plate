import 'package:equatable/equatable.dart';
import '../../../../core/loading_status.dart';

class CandidateManageState extends Equatable {
  final LoadingStatus loadingStatus;
  final String example;

  const CandidateManageState({
    required this.loadingStatus,
    required this.example,
  });

  const CandidateManageState.init()
      : loadingStatus = LoadingStatus.none,
        example = '';

  CandidateManageState copyWith({
    LoadingStatus? loadingStatus,
    String? example,
  }) =>
      CandidateManageState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        example: example ?? this.example,
      );

  @override
  List<Object> get props => <Object>[
        loadingStatus,
        example,
      ];
}
