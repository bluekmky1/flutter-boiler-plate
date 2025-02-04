// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileEntity _$ProfileEntityFromJson(Map<String, dynamic> json) =>
    ProfileEntity(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      userName: json['userName'] as String,
      governanceId: (json['governanceId'] as num).toInt(),
    );

Map<String, dynamic> _$ProfileEntityToJson(ProfileEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'userName': instance.userName,
      'governanceId': instance.governanceId,
    };
