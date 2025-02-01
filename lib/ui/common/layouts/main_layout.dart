import 'package:flutter/material.dart';
import '../consts/breakpoints.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/navigation_drawer.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const ResponsiveAppBar(),
        body: child,
        drawer: const AppNavigationDrawer(),
      );
}
