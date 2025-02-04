import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/common/data/api_response.dart';
import '../../core/common/data/message_response.dart';
import '../../service/network/dio_service.dart';
import 'entity/profile_entity.dart';
import 'entity/sign_in_entity.dart';
import 'request_body/sign_in_request_body.dart';
import 'request_body/sign_up_request_body.dart';

part 'generated/auth_remote_data_source.g.dart';

final Provider<AuthRemoteDataSource> authRemoteDataSourceProvider =
    Provider<AuthRemoteDataSource>(
  (ProviderRef<AuthRemoteDataSource> ref) =>
      AuthRemoteDataSource(ref.read(dioServiceProvider)),
);

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  @POST('/auth/sign-in')
  Future<ApiResponse<SignInEntity>> signIn({
    @Body() required SignInRequestBody signInRequestBody,
  });

  @POST('/auth/sign-up')
  Future<ApiResponse<MessageResponse>> signUp({
    @Body() required SignUpRequestBody signUpRequestBody,
  });

  @GET('/auth/whoAmI')
  Future<ApiResponse<ProfileEntity>> getProfile();
}
