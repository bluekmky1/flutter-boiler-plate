import 'package:equatable/equatable.dart';
import 'models/vote_data.dart';

class VoteAnalyticsState extends Equatable {
  final int totalStudents;
  final List<DailyVote> dailyVotes;
  final bool isLoading;
  final String? error;

  const VoteAnalyticsState({
    this.totalStudents = 0,
    this.dailyVotes = const <DailyVote>[],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props =>
      <Object?>[totalStudents, dailyVotes, isLoading, error];

  VoteAnalyticsState copyWith({
    int? totalStudents,
    List<DailyVote>? dailyVotes,
    bool? isLoading,
    String? error,
  }) =>
      VoteAnalyticsState(
        totalStudents: totalStudents ?? this.totalStudents,
        dailyVotes: dailyVotes ?? this.dailyVotes,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );

  // 편의 메서드
  int get totalVoters =>
      dailyVotes.fold(0, (int sum, DailyVote vote) => sum + vote.voterCount);

  double get votingRate =>
      totalStudents > 0 ? (totalVoters / totalStudents) * 100 : 0;
}
