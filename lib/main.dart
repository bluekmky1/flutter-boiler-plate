import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'routes/app_router.dart';
import 'service/app/app_service.dart';
import 'theme/vote_admin_colors.dart';

void main() {
  // URL에서 # 제거
  setUrlStrategy(PathUrlStrategy());

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    ref.read(appServiceProvider.notifier).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: ref.watch(appRouterProvider).router,
        title: '명지대 선거 어드민 페이지',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: VoteAdminColors.primary,
            onPrimary: VoteAdminColors.onPrimary,
            secondary: VoteAdminColors.secondary,
            onSecondary: VoteAdminColors.onSecondary,
            error: VoteAdminColors.error,
            onError: VoteAdminColors.onError,
            surface: VoteAdminColors.surface,
            onSurface: VoteAdminColors.onSurface,
          ),
          fontFamily: 'SUIT',
          appBarTheme: const AppBarTheme(
            backgroundColor: VoteAdminColors.white,
            foregroundColor: VoteAdminColors.primary,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          scaffoldBackgroundColor: VoteAdminColors.background,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: VoteAdminColors.primary,
              foregroundColor: VoteAdminColors.onPrimary,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: VoteAdminColors.primary,
            ),
          ),
        ),
      );
}
