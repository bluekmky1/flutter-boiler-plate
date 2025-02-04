import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/consts/breakpoints.dart';
import '../common/layouts/main_layout.dart';

class ManageUserView extends ConsumerStatefulWidget {
  const ManageUserView({super.key});

  @override
  ConsumerState<ManageUserView> createState() => _ManageUserViewState();
}

class _ManageUserViewState extends ConsumerState<ManageUserView> {
  int? selectedUserIndex;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth >= Breakpoints.desktop
        ? Breakpoints.desktopContentWidth
        : screenWidth >= Breakpoints.tablet
            ? screenWidth * 0.8
            : screenWidth;

    return MainLayout(
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= Breakpoints.desktop
                  ? Breakpoints.desktopPadding
                  : screenWidth >= Breakpoints.tablet
                      ? Breakpoints.tabletPadding
                      : Breakpoints.mobilePadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '회원 관리',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                if (screenWidth < Breakpoints.tablet) ...<Widget>[
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  _buildMemberList(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: _buildMemberList(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: _buildActionButtons(),
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

  Widget _buildMemberList() => Card(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 400, // 최대 높이 설정
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(), // 스크롤 가능하도록 변경
            itemCount: 6, // 샘플 데이터 개수
            separatorBuilder: (BuildContext context, int index) =>
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected = selectedUserIndex == index;
              return ListTile(
                leading: CircleAvatar(
                  child: Text(index == 0 ? '홍' : '김'),
                ),
                title: Text(index == 0 ? '홍길동' : '김철수'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    Text('소속: ${index == 0 ? '개발팀' : '디자인팀'}'),
                    const SizedBox(height: 2),
                    Text('가입 신청일: ${index == 0 ? '2024-03-20' : '2024-03-19'}'),
                  ],
                ),
                selected: isSelected,
                selectedTileColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.1),
                onTap: () {
                  setState(() {
                    selectedUserIndex = isSelected ? null : index;
                  });
                },
              );
            },
          ),
        ),
      );

  Widget _buildActionButtons() => Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: selectedUserIndex != null
                      ? () {
                          // TODO: 승인 로직 구현
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '승인',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: selectedUserIndex != null
                      ? () {
                          // TODO: 거절 로직 구현
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '거절',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
