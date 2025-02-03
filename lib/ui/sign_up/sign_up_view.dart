import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/loading_status.dart';
import '../common/consts/breakpoints.dart';
import '../common/consts/governances.dart';
import 'sign_up_state.dart';
import 'sign_up_view_model.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  String? _selectedGovernanceId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignUpState state = ref.watch(signUpViewModelProvider);
    final SignUpViewModel viewModel =
        ref.read(signUpViewModelProvider.notifier);

    ref.listen(
      signUpViewModelProvider
          .select((SignUpState state) => state.signUpLoadingStatus),
      (LoadingStatus? previous, LoadingStatus next) {
        if (next == LoadingStatus.success) {
          context.pop();
        }
      },
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 화면 너비에 따라 다른 레이아웃 적용
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
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '이름',
                          hintText: '홍길동',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          filled: isWideScreen,
                          fillColor: isWideScreen
                              ? Theme.of(context).colorScheme.surface
                              : null,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                          if (value.length < 6) {
                            return '비밀번호는 6자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: '비밀번호 확인',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: isWideScreen,
                          fillColor: isWideScreen
                              ? Theme.of(context).colorScheme.surface
                              : null,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 다시 입력해주세요';
                          }
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDepartmentDropdown(),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedGovernanceId == null) {
                              return;
                            }
                            viewModel.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              governanceId: _selectedGovernanceId!,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('회원가입'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('이미 계정이 있으신가요? 로그인하기'),
                      ),
                      const SizedBox(height: 16),
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

  Widget _buildDepartmentDropdown() => DropdownButtonFormField<String>(
        value: _selectedGovernanceId,
        decoration: const InputDecoration(
          labelText: '소속',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.business),
        ),
        items: Governances.governanceList
            .map((GovernanceInfo governance) => DropdownMenuItem<String>(
                  value: governance.id,
                  child: Text(
                    governance.governanceType == governance.governanceName
                        ? governance.governanceName
                        : '${governance.governanceType} ${governance.governanceName}',
                  ),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGovernanceId = newValue;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '소속을 선택해주세요';
          }
          return null;
        },
      );
}
