import 'package:json_annotation/json_annotation.dart';
part 'generated/sign_in_entity.g.dart';

@JsonSerializable()
class SignInEntity {
  const SignInEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  final String accessToken;
  final String refreshToken;
  final String role;

  factory SignInEntity.fromJson(Map<String, dynamic> json) =>
      _$SignInEntityFromJson(json);
}
