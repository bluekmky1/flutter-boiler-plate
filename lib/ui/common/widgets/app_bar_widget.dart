import 'package:flutter/material.dart';

import '../consts/assets.dart';
import '../consts/breakpoints.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: false,
        title: SizedBox(
          height: preferredSize.height,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            final double screenWidth = MediaQuery.of(context).size.width;
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Assets.mjuLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                if (screenWidth > Breakpoints.mobile)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('명지대 선거 관리 페이지'),
                  ),
              ],
            );
          }),
        ),
      );
}
