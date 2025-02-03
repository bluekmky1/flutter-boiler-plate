import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes.dart';
import '../../../service/app/app_service.dart';

class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppService appService = ref.read(appServiceProvider.notifier);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String currentRoute = GoRouterState.of(context).uri.path;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth < 400
          ? screenWidth * 0.80 // 모바일: 화면의 85%
          : 320, // 태블릿/데스크톱: 화면의 30%
      backgroundColor: colorScheme.onPrimary,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'ICT융합대학 선거관리위원회',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'michaelsmith123@gmail.com',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    onPressed: appService.signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('로그아웃'),
                  ),
                ),
              ],
            ),
          ),
          _NavigationDrawerItem(
            icon: Icons.home,
            label: '홈',
            isSelected: currentRoute == Routes.home.path,
            onPressed: () {
              context.goNamed(Routes.home.name);
            },
          ),

          _NavigationDrawerItem(
            icon: Icons.person,
            label: '후보자 정보 관리',
            isSelected: currentRoute == Routes.candidateManage.path,
            onPressed: () {
              context.goNamed(Routes.candidateManage.name);
            },
          ),
          _NavigationDrawerItem(
            icon: Icons.article,
            label: '게시글 관리',
            onPressed: () {},
          ),

          const Padding(
            padding: EdgeInsets.only(top: 32.0, left: 16.0),
            child: Text(
              '관리자 전용',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 32,
            color: colorScheme.primary,
          ),
          // 관리자 전용
          _NavigationDrawerItem(
            icon: Icons.settings_applications,
            label: '선거 관리',
            isSelected: currentRoute == Routes.manageVote.path,
            onPressed: () {
              context.goNamed(Routes.manageVote.name);
            },
          ),
          _NavigationDrawerItem(
            icon: Icons.campaign,
            label: '선거 공고 관리',
            isSelected: currentRoute == Routes.manageElectionNotice.path,
            onPressed: () {
              context.goNamed(Routes.manageElectionNotice.name);
            },
          ),
          _NavigationDrawerItem(
            icon: Icons.group,
            label: '후보자 승인 관리',
            isSelected: currentRoute == Routes.manageUser.path,
            onPressed: () {
              context.goNamed(Routes.manageUser.name);
            },
          ),
          _NavigationDrawerItem(
            icon: Icons.bar_chart,
            label: '투표율',
            isSelected: currentRoute == Routes.voteAnalytics.path,
            onPressed: () {
              context.goNamed(Routes.voteAnalytics.name);
            },
          ),
          _NavigationDrawerItem(
            icon: Icons.poll,
            label: '개표 결과',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _NavigationDrawerItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String label;
  final VoidCallback? onPressed;

  const _NavigationDrawerItem({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24),
          backgroundColor:
              isSelected ? colorScheme.primary : colorScheme.onPrimary,
          foregroundColor:
              isSelected ? colorScheme.onPrimary : colorScheme.primary,
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
