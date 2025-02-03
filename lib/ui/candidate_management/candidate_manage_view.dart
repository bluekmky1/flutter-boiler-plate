import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/layouts/main_layout.dart';

class CandidateManageView extends ConsumerStatefulWidget {
  const CandidateManageView({super.key});

  @override
  ConsumerState<CandidateManageView> createState() =>
      _CandidateManageViewState();
}

class _CandidateManageViewState extends ConsumerState<CandidateManageView> {
  @override
  Widget build(BuildContext context) => const MainLayout(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '명지대학교 후보자 관리 페이지 입니다.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
