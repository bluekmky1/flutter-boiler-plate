import 'package:equatable/equatable.dart';
import '../../../../core/loading_status.dart';

class SignInState extends Equatable {
  final LoadingStatus signInLoadingStatus;
  final String emailErrorMessage;
  final String passwordErrorMessage;

  const SignInState({
    required this.signInLoadingStatus,
    required this.emailErrorMessage,
    required this.passwordErrorMessage,
  });

  const SignInState.init()
      : signInLoadingStatus = LoadingStatus.none,
        emailErrorMessage = '',
        passwordErrorMessage = '';

  SignInState copyWith({
    LoadingStatus? signInLoadingStatus,
    String? emailErrorMessage,
    String? passwordErrorMessage,
  }) =>
      SignInState(
        signInLoadingStatus: signInLoadingStatus ?? this.signInLoadingStatus,
        emailErrorMessage: emailErrorMessage ?? this.emailErrorMessage,
        passwordErrorMessage: passwordErrorMessage ?? this.passwordErrorMessage,
      );

  @override
  List<Object> get props => <Object>[
        signInLoadingStatus,
        emailErrorMessage,
        passwordErrorMessage,
      ];
}
