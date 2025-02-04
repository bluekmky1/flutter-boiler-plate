import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes.dart';
import '../../../service/app/app_service.dart';
import '../consts/governances.dart';

class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppService appService = ref.read(appServiceProvider.notifier);
    final String role = ref.read(appServiceProvider).role;
    final String userName = ref.read(appServiceProvider).userName;
    final String email = ref.read(appServiceProvider).email;
    final GovernanceInfo governanceInfo =
        ref.read(appServiceProvider).governanceInfo;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String currentRoute = GoRouterState.of(context).uri.path;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth < 400
          ? screenWidth * 0.80 // 모바일: 화면의 85%
          : 320, // 태블릿/데스크톱: 화면의 30%
      backgroundColor: colorScheme.onPrimary,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${governanceInfo.governanceType} ${governanceInfo.governanceName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
          if (role == 'USER')
            _NavigationDrawerItem(
              icon: Icons.person,
              label: '후보자 정보 관리',
              isSelected: currentRoute == Routes.candidateManage.path,
              onPressed: () {
                context.goNamed(Routes.candidateManage.name);
              },
            ),
          if (role == 'ADMIN')
            // 관리자 전용
            Column(
              children: <Widget>[
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
                  isSelected: currentRoute == Routes.manageVoteResult.path,
                  onPressed: () {
                    context.goNamed(Routes.manageVoteResult.name);
                  },
                ),
              ],
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
          minimumSize: const Size(double.infinity, 48),
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
