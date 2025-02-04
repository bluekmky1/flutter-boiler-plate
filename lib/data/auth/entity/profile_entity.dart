import 'package:json_annotation/json_annotation.dart';
part 'generated/profile_entity.g.dart';

@JsonSerializable()
class ProfileEntity {
  const ProfileEntity({
    required this.userId,
    required this.email,
    required this.userName,
    required this.governanceId,
  });

  final int userId;
  final String email;
  final String userName;
  final int governanceId;

  factory ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);
}
