import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/auth/entity/auth_token_entity.dart';
// import '../storage/storage_key.dart';
// import '../storage/storage_service.dart';
// import '../../data/auth/entity/auth_token_entity.dart';
// import '../storage/storage_key.dart';
// import '../storage/storage_service.dart';
import '../../data/auth/entity/auth_token_entity.dart';
import '../../domain/auth/model/profile_model.dart';
import '../../ui/common/consts/governances.dart';
import '../storage/storage_key.dart';
import '../storage/storage_service.dart';
import 'app_state.dart';

final StateNotifierProvider<AppService, AppState> appServiceProvider =
    StateNotifierProvider<AppService, AppState>(
  (Ref ref) => AppService(
    storageService: ref.watch(storageServiceProvider),
    state: AppState.init(),
  ),
);

class AppService extends StateNotifier<AppState> {
  AppService({
    required StorageService storageService,
    required AppState state,
  })  : _storageService = storageService,
        super(state) {
    // init();
  }

  // 로그인 관련 기본 설정들
  final StorageService _storageService;

  Future<void> init() async {
    final String? accessToken =
        await _storageService.getString(key: StorageKey.accessToken);
    final String? refreshToken =
        await _storageService.getString(key: StorageKey.refreshToken);
    final String? userName =
        await _storageService.getString(key: StorageKey.userName);
    final String? email =
        await _storageService.getString(key: StorageKey.email);
    final String? governanceId =
        await _storageService.getString(key: StorageKey.governanceId);
    final String? governanceType =
        await _storageService.getString(key: StorageKey.governanceType);
    final String? governanceName =
        await _storageService.getString(key: StorageKey.governanceName);

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(
        isSignedIn: true,
        userName: userName,
        email: email,
        governanceInfo: governanceId != null &&
                governanceType != null &&
                governanceName != null
            ? GovernanceInfo(
                id: governanceId,
                governanceName: governanceName,
                governanceType: governanceType,
              )
            : null,
      );
    }
  }

  Future<void> signIn({
    required AuthTokenEntity authTokens,
    required String role,
  }) async {
    await _storageService.setString(
      key: StorageKey.accessToken,
      value: authTokens.accessToken,
    );
    await _storageService.setString(
      key: StorageKey.refreshToken,
      value: authTokens.refreshToken,
    );

    await _storageService.setString(
      key: StorageKey.role,
      value: role,
    );

    state = state.copyWith(isSignedIn: true, role: role);
  }

  Future<void> signOut() async {
    state = state.copyWith(isSignedIn: false);
    await _storageService.clearAll();
  }

  Future<void> setProfile({
    required ProfileModel profile,
  }) async {
    await _storageService.setString(
      key: StorageKey.userName,
      value: profile.userName,
    );

    await _storageService.setString(
      key: StorageKey.email,
      value: profile.email,
    );

    await _storageService.setString(
      key: StorageKey.governanceId,
      value: profile.governanceInfo.id,
    );

    await _storageService.setString(
      key: StorageKey.governanceType,
      value: profile.governanceInfo.governanceType,
    );

    await _storageService.setString(
      key: StorageKey.governanceName,
      value: profile.governanceInfo.governanceName,
    );

    state = state.copyWith(
      userName: profile.userName,
      email: profile.email,
      governanceInfo: profile.governanceInfo,
    );
  }
}
