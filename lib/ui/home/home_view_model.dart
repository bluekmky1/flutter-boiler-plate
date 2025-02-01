import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/app/app_service.dart';
import 'home_state.dart';

final AutoDisposeStateNotifierProvider<HomeViewModel, HomeState>
    homeViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<HomeState> ref) => HomeViewModel(
    state: const HomeState.init(),
    appService: ref.watch(appServiceProvider.notifier),
  ),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final AppService _appService;
  HomeViewModel({
    required HomeState state,
    required AppService appService,
  })  : _appService = appService,
        super(state);

  void onSignOut() {
    _appService.signOut();
  }
}
