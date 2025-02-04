import 'package:equatable/equatable.dart';

import '../../../data/auth/entity/profile_entity.dart';
import '../../../ui/common/consts/governances.dart';

class ProfileModel extends Equatable {
  final String email;
  final String userName;
  final GovernanceInfo governanceInfo;

  const ProfileModel({
    required this.email,
    required this.userName,
    required this.governanceInfo,
  });

  factory ProfileModel.fromEntity({
    required ProfileEntity entity,
  }) =>
      ProfileModel(
        email: entity.email,
        userName: entity.userName,
        governanceInfo: Governances.getGovernanceById(
          entity.governanceId.toString(),
        ),
      );

  @override
  List<Object?> get props => <Object?>[
        email,
        userName,
        governanceInfo,
      ];
}
