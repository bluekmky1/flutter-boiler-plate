// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

import '../common/layouts/main_layout.dart';

class ManageElectionNoticeView extends ConsumerStatefulWidget {
  const ManageElectionNoticeView({super.key});

  @override
  ConsumerState<ManageElectionNoticeView> createState() =>
      _ManageElectionNoticeViewState();
}

class _ManageElectionNoticeViewState
    extends ConsumerState<ManageElectionNoticeView> {
  List<String> images = <String>[];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return MainLayout(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '선거 공고',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 16),
                    // 변경 사항 저장용 버튼
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 변경 사항 저장
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                        backgroundColor: colorScheme.primary,
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text('변경사항 저장'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 332,
                        child: Column(
                          children: <Widget>[
                            _buildCard(
                              title: '선거관리위원회 구성 공고',
                            ),
                            _buildPreviewImages(
                              context,
                              image: '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16), // 카드 사이 간격
                      SizedBox(
                        width: 332,
                        child: Column(
                          children: <Widget>[
                            _buildCard(
                              title: '선거시행세칙 구성 공고',
                            ),
                            _buildPreviewImages(
                              context,
                              image: '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 332,
                        child: Column(
                          children: <Widget>[
                            _buildCard(
                              title: '후보자 모집 공고',
                            ),
                            _buildPreviewImages(
                              context,
                              image: '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 332,
                        child: Column(
                          children: <Widget>[
                            _buildCard(
                              title: '선거 세칙',
                            ),
                            _buildPreviewImages(
                              context,
                              image: 'example1.png',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title}) => Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            // TODO: 카드 클릭 이벤트 처리
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.settings),
              ],
            ),
          ),
        ),
      );

  Widget _buildPreviewImages(
    BuildContext context, {
    required String image,
  }) =>
      Column(
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) =>
                          Container(
                        width: double.infinity,
                        height: 500,
                        color: Colors.grey,
                        child: const Center(
                          child: Text('이미지를 불러올 수 없습니다.'),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('등록된 선거 공고가 없습니다.'),
                    ),
            ),
          ),
        ],
      );
}
