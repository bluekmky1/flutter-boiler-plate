import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/loading_status.dart';
import '../../routes/routes.dart';
import '../common/consts/breakpoints.dart';
import 'sign_in_state.dart';
import 'sign_in_view_model.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignInViewModel viewModel =
        ref.read(signInViewModelProvider.notifier);

    ref.listen(
      signInViewModelProvider
          .select((SignInState state) => state.signInLoadingStatus),
      (LoadingStatus? previous, LoadingStatus next) {
        if (next == LoadingStatus.success) {
          context.goNamed(Routes.home.name);
        }
      },
    );

    // 테스트 계정
    // hazardous10@naver.com
    // 1234

    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isWideScreen = constraints.maxWidth > Breakpoints.mobile;
          final double contentWidth = isWideScreen
              ? Breakpoints.tabletContentWidth
              : constraints.maxWidth;
          final double horizontalPadding = isWideScreen
              ? Breakpoints.tabletPadding
              : Breakpoints.mobilePadding;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Breakpoints.mobilePadding),
              child: Container(
                width: contentWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: Breakpoints.tabletPadding,
                ),
                decoration: isWideScreen
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      )
                    : null,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: isWideScreen
                              ? Breakpoints.tabletPadding
                              : Breakpoints.mobilePadding,
                        ),
                        child: Text(
                          '명지대 선거 어드민 페이지',
                          style: TextStyle(
                            fontSize: isWideScreen ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          hintText: 'example@email.com',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          filled: isWideScreen,
                          fillColor: isWideScreen
                              ? Theme.of(context).colorScheme.surface
                              : null,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          if (!value.contains('@')) {
                            return '올바른 이메일 형식이 아닙니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Breakpoints.mobilePadding),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          filled: isWideScreen,
                          fillColor: isWideScreen
                              ? Theme.of(context).colorScheme.surface
                              : null,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: Breakpoints.mobilePadding,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: <Widget>[
                      //       TextButton(
                      //         onPressed: () {},
                      //         child: const Text('비밀번호를 잊으셨나요?'),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: Breakpoints.mobilePadding),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('로그인'),
                      ),
                      const SizedBox(height: Breakpoints.mobilePadding),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(Routes.signUp.name);
                        },
                        child: const Text('계정이 없으신가요? 회원가입하기'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
