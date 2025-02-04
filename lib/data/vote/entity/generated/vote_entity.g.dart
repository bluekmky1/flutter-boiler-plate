// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../vote_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteEntity _$VoteEntityFromJson(Map<String, dynamic> json) => VoteEntity(
      voteName: json['voteName'] as String,
      voteDateTime: json['voteDateTime'] as String,
      voteDescription: json['voteDescription'] as String,
      fileUrl: json['fileUrl'] as String,
    );

Map<String, dynamic> _$VoteEntityToJson(VoteEntity instance) =>
    <String, dynamic>{
      'voteName': instance.voteName,
      'voteDateTime': instance.voteDateTime,
      'voteDescription': instance.voteDescription,
      'fileUrl': instance.fileUrl,
    };
