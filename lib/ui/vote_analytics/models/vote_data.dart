import 'package:equatable/equatable.dart';

class VoteData extends Equatable {
  final int totalStudents;
  final List<DailyVote> dailyVotes;

  const VoteData({
    required this.totalStudents,
    this.dailyVotes = const <DailyVote>[],
  });

  @override
  List<Object?> get props => <Object?>[totalStudents, dailyVotes];

  // 편의 메서드들
  int get totalVoters =>
      dailyVotes.fold(0, (int sum, DailyVote vote) => sum + vote.voterCount);

  double get votingRate =>
      totalStudents > 0 ? (totalVoters / totalStudents) * 100 : 0;

  bool get hasVotes => dailyVotes.isNotEmpty;

  // 복사 메서드
  VoteData copyWith({
    int? totalStudents,
    List<DailyVote>? dailyVotes,
  }) =>
      VoteData(
        totalStudents: totalStudents ?? this.totalStudents,
        dailyVotes: dailyVotes ?? this.dailyVotes,
      );
}

class DailyVote extends Equatable {
  final DateTime date;
  final int voterCount;

  const DailyVote({
    required this.date,
    required this.voterCount,
  });

  @override
  List<Object?> get props => <Object?>[date, voterCount];

  // 복사 메서드
  DailyVote copyWith({
    DateTime? date,
    int? voterCount,
  }) =>
      DailyVote(
        date: date ?? this.date,
        voterCount: voterCount ?? this.voterCount,
      );
}
