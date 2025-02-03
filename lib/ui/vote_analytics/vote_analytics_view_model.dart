import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/vote_data.dart';
import 'vote_analytics_state.dart';

final StateNotifierProvider<VoteAnalyticsViewModel, VoteAnalyticsState>
    voteAnalyticsViewModelProvider =
    StateNotifierProvider<VoteAnalyticsViewModel, VoteAnalyticsState>(
  (StateNotifierProviderRef<VoteAnalyticsViewModel, VoteAnalyticsState> ref) =>
      VoteAnalyticsViewModel(),
);

class VoteAnalyticsViewModel extends StateNotifier<VoteAnalyticsState> {
  VoteAnalyticsViewModel() : super(const VoteAnalyticsState());

  void setTotalStudents(int count) {
    state = state.copyWith(totalStudents: count);
  }

  void addDailyVote(DailyVote vote) {
    try {
      state = state.copyWith(isLoading: true);

      // 같은 날짜의 데이터가 있는지 확인
      final int existingIndex = state.dailyVotes.indexWhere((DailyVote v) =>
          v.date.year == vote.date.year &&
          v.date.month == vote.date.month &&
          v.date.day == vote.date.day);

      final List<DailyVote> updatedVotes = <DailyVote>[...state.dailyVotes];

      if (existingIndex >= 0) {
        // 기존 데이터 업데이트
        updatedVotes[existingIndex] = vote;
      } else {
        // 새 데이터 추가
        updatedVotes.add(vote);
      }

      // 날짜순으로 정렬
      updatedVotes.sort((DailyVote a, DailyVote b) => a.date.compareTo(b.date));

      state = state.copyWith(
        dailyVotes: updatedVotes,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void removeDailyVote(DateTime date) {
    final List<DailyVote> updatedVotes =
        state.dailyVotes.where((DailyVote vote) => vote.date != date).toList();

    state = state.copyWith(dailyVotes: updatedVotes);
  }

  void resetData() {
    state = const VoteAnalyticsState();
  }
}
