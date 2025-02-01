import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

import '../common/layouts/main_layout.dart';

class ManageUserView extends ConsumerStatefulWidget {
  const ManageUserView({super.key});

  @override
  ConsumerState<ManageUserView> createState() => _ManageUserViewState();
}

class _ManageUserViewState extends ConsumerState<ManageUserView> {
  @override
  Widget build(BuildContext context) => const MainLayout(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '회원 관리 페이지 입니다.',
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
