import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/common/use_case/use_case_result.dart';
import '../../core/loading_status.dart';
import '../../domain/auth/model/profile_model.dart';
import '../../domain/auth/use_case/get_profile_use_case.dart';
import '../../service/app/app_service.dart';
import 'home_state.dart';

final AutoDisposeStateNotifierProvider<HomeViewModel, HomeState>
    homeViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<HomeState> ref) => HomeViewModel(
    state: const HomeState.init(),
    appService: ref.watch(appServiceProvider.notifier),
    getProfileUseCase: ref.read(getProfileUseCaseProvider),
  ),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final AppService _appService;
  final GetProfileUseCase _getProfileUseCase;
  HomeViewModel({
    required HomeState state,
    required AppService appService,
    required GetProfileUseCase getProfileUseCase,
  })  : _appService = appService,
        _getProfileUseCase = getProfileUseCase,
        super(state);

  Future<void> getProfile() async {
    state = state.copyWith(
      getProfileLoadingStatus: LoadingStatus.loading,
    );

    final UseCaseResult<ProfileModel> result = await _getProfileUseCase();

    switch (result) {
      case SuccessUseCaseResult<ProfileModel>():
        _appService.setProfile(profile: result.data);
        state = state.copyWith(
          getProfileLoadingStatus: LoadingStatus.success,
        );
      case FailureUseCaseResult<ProfileModel>():
        state = state.copyWith(
          getProfileLoadingStatus: LoadingStatus.error,
        );
    }
  }

  void onSignOut() {
    _appService.signOut();
  }
}
