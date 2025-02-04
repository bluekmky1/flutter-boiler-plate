import 'package:equatable/equatable.dart';

import '../../ui/common/consts/governances.dart';

/// 전역으로 관리하는 상태 EX) 로그인 상태
class AppState extends Equatable {
  final bool isSignedIn;
  final String role;
  final String userName;
  final String email;
  final GovernanceInfo governanceInfo;

  const AppState({
    required this.isSignedIn,
    required this.role,
    required this.userName,
    required this.email,
    required this.governanceInfo,
  });

  AppState.init()
      : isSignedIn = false,
        role = '',
        userName = '',
        email = '',
        governanceInfo = GovernanceInfo(
          id: '',
          governanceName: '',
          governanceType: '',
        );

  AppState copyWith({
    bool? isSignedIn,
    String? role,
    String? userName,
    String? email,
    GovernanceInfo? governanceInfo,
  }) =>
      AppState(
        isSignedIn: isSignedIn ?? this.isSignedIn,
        role: role ?? this.role,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        governanceInfo: governanceInfo ?? this.governanceInfo,
      );

  @override
  List<Object?> get props => <Object?>[
        isSignedIn,
        role,
        userName,
        email,
        governanceInfo,
      ];
}
