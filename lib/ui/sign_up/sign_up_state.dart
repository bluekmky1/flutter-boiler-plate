import 'package:equatable/equatable.dart';
import '../../../../core/loading_status.dart';

class SignUpState extends Equatable {
  final LoadingStatus signUpLoadingStatus;

  const SignUpState({
    required this.signUpLoadingStatus,
  });

  const SignUpState.init() : signUpLoadingStatus = LoadingStatus.none;

  SignUpState copyWith({
    LoadingStatus? signUpLoadingStatus,
  }) =>
      SignUpState(
        signUpLoadingStatus: signUpLoadingStatus ?? this.signUpLoadingStatus,
      );

  @override
  List<Object> get props => <Object>[
        signUpLoadingStatus,
      ];
}
