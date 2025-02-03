import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/vote_data.dart';
import '../vote_analytics_state.dart';
import '../vote_analytics_view_model.dart';

class DailyVoteTable extends ConsumerWidget {
  const DailyVoteTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VoteAnalyticsState state = ref.watch(voteAnalyticsViewModelProvider);
    final List<DailyVote> dailyVotes = state.dailyVotes;
    final int totalStudents = state.totalStudents;
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    if (dailyVotes.isEmpty) {
      return const Center(
        child: Text('투표 데이터가 없습니다'),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16.0 : 4.0,
        ),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(2), // 날짜
            1: FlexColumnWidth(1.5), // 투표자 수
            2: FlexColumnWidth(1.5), // 투표율
          },
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          children: <TableRow>[
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              children: const <Widget>[
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '날짜',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '투표자 수',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '투표율',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            ...dailyVotes.map((DailyVote vote) {
              final double votingRate = totalStudents > 0
                  ? (vote.voterCount / totalStudents * 100)
                  : 0.0;

              return TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        DateFormat('yyyy년 MM월 dd일').format(vote.date),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${vote.voterCount}명',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${votingRate.toStringAsFixed(1)}%',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
