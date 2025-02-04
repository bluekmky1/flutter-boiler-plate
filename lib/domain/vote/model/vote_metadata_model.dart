import 'package:equatable/equatable.dart';

import '../../../data/vote/entity/vote_entity.dart';

class VoteMetadataModel extends Equatable {
  final String voteName;
  final String voteDateTime;
  final String voteDescription;
  final String fileUrl;

  const VoteMetadataModel({
    required this.voteName,
    required this.voteDateTime,
    required this.voteDescription,
    required this.fileUrl,
  });

  factory VoteMetadataModel.fromEntity({
    required VoteEntity entity,
  }) =>
      VoteMetadataModel(
        voteName: entity.voteName,
        voteDateTime: entity.voteDateTime,
        voteDescription: entity.voteDescription,
        fileUrl: entity.fileUrl,
      );

  @override
  List<Object?> get props => <Object?>[
        voteName,
        voteDateTime,
        voteDescription,
        fileUrl,
      ];
}
