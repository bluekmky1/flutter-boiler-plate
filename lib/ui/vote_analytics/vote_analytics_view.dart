import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/layouts/main_layout.dart';

import 'widgets/daily_vote_chart.dart';
import 'widgets/daily_vote_table.dart';
import 'widgets/total_students_setting.dart';
import 'widgets/vote_input_form.dart';
import 'widgets/vote_pie_chart.dart';

class VoteAnalyticsView extends ConsumerWidget {
  const VoteAnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MainLayout(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: const Column(
                        children: <Widget>[
                          TotalStudentsSetting(),
                          SizedBox(height: 16),
                          VoteInputForm(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: SizedBox(
                      height: 600,
                      child: _ChartSection(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
}

class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1000,
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        '일별 투표율',
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '전체 투표율',
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '상세 내역',
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                    ),
                  ],
                  labelStyle: theme.textTheme.titleSmall,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '일별 투표율',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          const Expanded(child: DailyVoteChart()),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '전체 투표율',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          const Expanded(child: VotePieChart()),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '상세 내역',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          const Expanded(child: DailyVoteTable()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
