import 'package:equatable/equatable.dart';
import '../../../../core/loading_status.dart';

class HomeState extends Equatable {
  final LoadingStatus getProfileLoadingStatus;

  const HomeState({
    required this.getProfileLoadingStatus,
  });

  const HomeState.init() : getProfileLoadingStatus = LoadingStatus.none;

  HomeState copyWith({
    LoadingStatus? getProfileLoadingStatus,
  }) =>
      HomeState(
        getProfileLoadingStatus:
            getProfileLoadingStatus ?? this.getProfileLoadingStatus,
      );

  @override
  List<Object> get props => <Object>[
        getProfileLoadingStatus,
      ];
}
