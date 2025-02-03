// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/layouts/main_layout.dart';

class ManageVoteResultView extends ConsumerStatefulWidget {
  const ManageVoteResultView({super.key});

  @override
  ConsumerState<ManageVoteResultView> createState() =>
      _ManageVoteResultViewState();
}

class _ManageVoteResultViewState extends ConsumerState<ManageVoteResultView> {
  // 대학 목록
  final List<String> _colleges = <String>[
    '인문대학',
    '사회과학대학',
    '경영대학',
    '법과대학',
    'ICT융합대학',
    '미래융합대학',
  ];

  // 대학별 학과 목록
  final Map<String, List<String>> _departments = <String, List<String>>{
    '인문대학': <String>[
      '국어국문학과',
      '중어중문학과',
      '일어일문학과',
      '영어영문학과',
      '사학과',
      '문헌정보학과',
      '아랍지역학과',
      '미술사학과',
      '철학과'
    ],
    '사회과학대학': <String>['행정학과', '경제학과', '정치외교학과', '디지털미디어학과', '아동학과', '청소년지도학과'],
    '경영대학': <String>['경영학과', '국제통상학과', '부동산학과'],
    '법과대학': <String>['법학과'],
    'ICT융합대학': <String>['디지털콘텐츠디자인학과', '융합소프트웨어학부'],
    '미래융합대학': <String>[
      '창의융합인재학부',
      '사회복지학과',
      '부동산학과',
      '법무행정학과',
      '심리치료학과',
      '미래융합경영학과',
      '멀티디자인학과'
    ],
  };

  @override
  Widget build(BuildContext context) => MainLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '개표 결과 관리',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: MediaQuery.of(context).size.width >= 800
                                  ? 24
                                  : 20,
                            ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('개표 결과 등록'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
