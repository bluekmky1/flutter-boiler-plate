import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/data/api_response.dart';
import '../../core/common/data/message_response.dart';
import '../../core/common/repository/repository.dart';
import '../../core/common/repository/repository_result.dart';
import 'auth_remote_data_source.dart';
import 'entity/profile_entity.dart';
import 'entity/sign_in_entity.dart';
import 'request_body/sign_in_request_body.dart';
import 'request_body/sign_up_request_body.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (ProviderRef<AuthRepository> ref) => AuthRepository(
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
  ),
);

class AuthRepository extends Repository {
  final AuthRemoteDataSource _authRemoteDataSource;
  const AuthRepository({
    required AuthRemoteDataSource authRemoteDataSource,
  }) : _authRemoteDataSource = authRemoteDataSource;

  Future<RepositoryResult<ApiResponse<SignInEntity>>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return SuccessRepositoryResult<ApiResponse<SignInEntity>>(
        data: await _authRemoteDataSource.signIn(
          signInRequestBody: SignInRequestBody(
            email: email,
            password: password,
          ),
        ),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        404 => FailureRepositoryResult<ApiResponse<SignInEntity>>(
            error: e,
            messages: <String>['이메일 또는 비밀번호를 확인해 주세요.'],
          ),
        _ => FailureRepositoryResult<ApiResponse<SignInEntity>>(
            error: e,
            messages: <String>['로그인 실패'],
          ),
      };
    }
  }

  Future<RepositoryResult<ApiResponse<MessageResponse>>> signUp({
    required String email,
    required String password,
    required String name,
    required String governanceId,
  }) async {
    try {
      return SuccessRepositoryResult<ApiResponse<MessageResponse>>(
        data: await _authRemoteDataSource.signUp(
          signUpRequestBody: SignUpRequestBody(
            email: email,
            password: password,
            name: name,
            governanceId: governanceId,
          ),
        ),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        _ => FailureRepositoryResult<ApiResponse<MessageResponse>>(
            error: e,
            messages: <String>['회원가입 실패'],
          ),
      };
    }
  }

  Future<RepositoryResult<ApiResponse<ProfileEntity>>> getProfile() async {
    try {
      return SuccessRepositoryResult<ApiResponse<ProfileEntity>>(
        data: await _authRemoteDataSource.getProfile(),
      );
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;

      return switch (statusCode) {
        _ => FailureRepositoryResult<ApiResponse<ProfileEntity>>(
            error: e,
            messages: <String>['프로필 조회 실패'],
          ),
      };
    }
  }
}
