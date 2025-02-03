import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/app/app_service.dart';
import 'candidate_manage_state.dart';

final AutoDisposeStateNotifierProvider<CandidateManageViewModel,
        CandidateManageState> candidateManageViewModelProvider =
    StateNotifierProvider.autoDispose(
  (AutoDisposeRef<CandidateManageState> ref) => CandidateManageViewModel(
    state: const CandidateManageState.init(),
    appService: ref.watch(appServiceProvider.notifier),
  ),
);

class CandidateManageViewModel extends StateNotifier<CandidateManageState> {
  final AppService _appService;
  CandidateManageViewModel({
    required CandidateManageState state,
    required AppService appService,
  })  : _appService = appService,
        super(state);

  void onSignOut() {
    _appService.signOut();
  }
}
