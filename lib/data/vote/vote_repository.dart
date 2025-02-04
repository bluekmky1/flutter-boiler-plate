import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/common/data/api_response.dart';
import '../../core/common/data/message_response.dart';
import '../../core/common/repository/repository.dart';
import '../../core/common/repository/repository_result.dart';
import '../../service/network/dio_service.dart';
import '../../util/date_time_format_helper.dart';
import 'entity/vote_entity.dart';
import 'vote_remote_data_source.dart';

final Provider<VoteRepository> voteRepositoryProvider =
    Provider<VoteRepository>(
  (ProviderRef<VoteRepository> ref) => VoteRepository(
    ref.watch(voteRemoteDataSourceProvider),
    ref.read(dioServiceProvider),
  ),
);

class VoteRepository extends Repository {
  VoteRepository(
    this._voteRemoteDataSource,
    Dio dio,
  ) : _dio = dio;

  final VoteRemoteDataSource _voteRemoteDataSource;
  final Dio _dio;

  /// 선거 메타데이터 조회
  Future<RepositoryResult<ApiResponse<VoteEntity>>> getVoteMetadata() async {
    try {
      return SuccessRepositoryResult<ApiResponse<VoteEntity>>(
        data: await _voteRemoteDataSource.getVoteMetadata(),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        _ => FailureRepositoryResult<ApiResponse<VoteEntity>>(
            error: e,
            messages: <String>['데이터 불러오는 과정에 오류가 있습니다'],
          ),
      };
    }
  }

  /// 선거 초기화
  Future<RepositoryResult<ApiResponse<MessageResponse>>> resetVote() async {
    try {
      return SuccessRepositoryResult<ApiResponse<MessageResponse>>(
        data: await _voteRemoteDataSource.resetVote(),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        _ => FailureRepositoryResult<ApiResponse<MessageResponse>>(
            error: e,
            messages: <String>['선거 초기화에 실패했습니다.'],
          ),
      };
    }
  }

  /// 선거 생성
  Future<RepositoryResult<ApiResponse<MessageResponse>>> createVote({
    required String voteName,
    required String voteDateTime,
    required String voteDescription,
    required Uint8List image,
  }) async {
    try {
      final FormData body = FormData();
      final MultipartFile imageFile = MultipartFile.fromBytes(
        contentType: MediaType('image', 'png'),
        image,
        filename:
            '${DateTimeFormatter.getNumburicDateTime(DateTime.now())}.png',
      );
      final MapEntry<String, MultipartFile> imageEntry =
          MapEntry<String, MultipartFile>('file', imageFile);
      body.files.add(imageEntry);
      body.fields.add(MapEntry<String, String>('voteName', voteName));
      body.fields.add(MapEntry<String, String>('voteDateTime', voteDateTime));
      body.fields
          .add(MapEntry<String, String>('voteDescription', voteDescription));

      _dio.options.contentType = Headers.multipartFormDataContentType;
      final Response<dynamic> response = await _dio.post(
        'http://13.125.244.156:8080/api/v1/vote',
        data: body,
      );
      _dio.options.contentType = Headers.jsonContentType;
      return SuccessRepositoryResult<ApiResponse<MessageResponse>>(
        data: ApiResponse<MessageResponse>.fromJson(
          response.data,
          (Object? json) =>
              MessageResponse.fromJson(json! as Map<String, dynamic>),
        ),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        _ => FailureRepositoryResult<ApiResponse<MessageResponse>>(
            error: e,
            messages: <String>['선거 생성에 실패했습니다. / 에러코드 : $statusCode'],
          ),
      };
    }
  }
}
