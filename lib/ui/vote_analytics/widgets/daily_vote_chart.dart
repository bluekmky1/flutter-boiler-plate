import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vote_data.dart';
import '../vote_analytics_state.dart';
import '../vote_analytics_view_model.dart';

class DailyVoteChart extends ConsumerWidget {
  const DailyVoteChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VoteAnalyticsState state = ref.watch(voteAnalyticsViewModelProvider);
    final List<DailyVote> dailyVotes = state.dailyVotes;
    final int totalStudents = state.totalStudents;

    if (dailyVotes.isEmpty) {
      return const Center(
        child: Text('투표 데이터가 없습니다'),
      );
    }

    final int maxVoters = dailyVotes
        .map((DailyVote vote) => vote.voterCount)
        .reduce((int max, int count) => count > max ? count : max);
    // y축 최대값을 5단위로 올림
    final double yAxisMax = ((maxVoters / 5).ceil() * 5).toDouble();
    // y축 간격 계산
    final double yInterval = yAxisMax / 4; // 0부터 시작하므로 4로 나누어 5개의 구간 생성

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  horizontalInterval: yInterval, // 계산된 간격 사용
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: yInterval, // 계산된 간격 사용
                      getTitlesWidget: (double value, TitleMeta meta) =>
                          Text('${value.toInt()}명'),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < dailyVotes.length) {
                          final DateTime date = dailyVotes[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: (dailyVotes.length - 1).toDouble(),
                minY: 0,
                maxY: yAxisMax,
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: dailyVotes
                        .asMap()
                        .entries
                        .map((MapEntry<int, DailyVote> entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value.voterCount.toDouble(),
                            ))
                        .toList(),
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) =>
                        touchedSpots.map((LineBarSpot spot) {
                      final DateTime date = dailyVotes[spot.x.toInt()].date;
                      final int voterCount =
                          dailyVotes[spot.x.toInt()].voterCount;
                      final double votingRate = totalStudents > 0
                          ? (voterCount / totalStudents * 100)
                          : 0.0;
                      return LineTooltipItem(
                        '${date.month}/${date.day}\n'
                        '$voterCount명\n'
                        '(${votingRate.toStringAsFixed(1)}%)',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
