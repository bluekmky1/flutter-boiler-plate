import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/common/data/api_response.dart';
import '../../core/common/data/message_response.dart';
import '../../service/network/dio_service.dart';
import 'entity/vote_entity.dart';

part 'generated/vote_remote_data_source.g.dart';

final Provider<VoteRemoteDataSource> voteRemoteDataSourceProvider =
    Provider<VoteRemoteDataSource>(
  (ProviderRef<VoteRemoteDataSource> ref) =>
      VoteRemoteDataSource(ref.read(dioServiceProvider)),
);

@RestApi()
abstract class VoteRemoteDataSource {
  factory VoteRemoteDataSource(Dio dio) = _VoteRemoteDataSource;

  // 선거 조회
  @GET('/vote/metadata')
  Future<ApiResponse<VoteEntity>> getVoteMetadata();

  // 선거 초기화
  @POST('/vote/reset')
  Future<ApiResponse<MessageResponse>> resetVote();
}
