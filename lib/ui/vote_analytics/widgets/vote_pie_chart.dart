import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../vote_analytics_state.dart';
import '../vote_analytics_view_model.dart';

class VotePieChart extends ConsumerWidget {
  const VotePieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VoteAnalyticsState state = ref.watch(voteAnalyticsViewModelProvider);
    final int totalStudents = state.totalStudents;
    final int totalVoters = state.totalVoters;

    if (totalStudents == 0) {
      return const Center(
        child: Text('전체 학생 수를 먼저 입력해주세요'),
      );
    }

    final double votingRate = (totalVoters / totalStudents) * 100;
    final num nonVotingRate = 100 - votingRate;
    final int remainingVoters = totalStudents - totalVoters;

    // 차트 섹션 색상 정의
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor =
        Theme.of(context).colorScheme.secondaryContainer;

    // 텍스트 색상은 배경색에 따라 자동으로 선택
    final Color primaryTextColor =
        primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final Color secondaryTextColor =
        Theme.of(context).colorScheme.onSecondaryContainer;

    // 화면 너비에 따라 차트 크기 결정
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double chartSize = isDesktop ? 300.0 : 180.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: SizedBox(
                  height: chartSize,
                  width: chartSize,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      startDegreeOffset: 270,
                      sections: <PieChartSectionData>[
                        PieChartSectionData(
                          color: primaryColor,
                          value: totalVoters.toDouble(),
                          title: '${votingRate.toStringAsFixed(1)}%',
                          radius: chartSize / 2,
                          titleStyle: TextStyle(
                            fontSize: isDesktop ? 18 : 14,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            shadows: const <Shadow>[
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          showTitle: votingRate >= 10,
                        ),
                        PieChartSectionData(
                          color: secondaryColor,
                          value: remainingVoters.toDouble(),
                          title: '${nonVotingRate.toStringAsFixed(1)}%',
                          radius: chartSize / 2,
                          titleStyle: TextStyle(
                            fontSize: isDesktop ? 18 : 14,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                            shadows: const <Shadow>[
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          showTitle: nonVotingRate >= 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildLegendItem(
                  context,
                  '투표 완료',
                  '$totalVoters명',
                  primaryColor,
                ),
                _buildLegendItem(
                  context,
                  '미투표',
                  '$remainingVoters명',
                  secondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '전체: $totalStudents명',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      );
}
