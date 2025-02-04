import 'package:json_annotation/json_annotation.dart';
part 'generated/vote_entity.g.dart';

@JsonSerializable()
class VoteEntity {
  const VoteEntity({
    required this.voteName,
    required this.voteDateTime,
    required this.voteDescription,
    required this.fileUrl,
  });

  final String voteName;
  final String voteDateTime;
  final String voteDescription;
  final String fileUrl;

  factory VoteEntity.fromJson(Map<String, dynamic> json) =>
      _$VoteEntityFromJson(json);
}
