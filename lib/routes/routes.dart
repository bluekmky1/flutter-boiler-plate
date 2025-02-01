import 'route_info.dart';

class Routes {
  // auth
  static const RouteInfo auth = RouteInfo(
    name: '/auth',
    path: '/auth',
  );

  static const RouteInfo signIn = RouteInfo(
    name: '/auth/sign-in',
    path: 'sign-in',
  );

  static const RouteInfo signUp = RouteInfo(
    name: '/auth/sign-up',
    path: 'sign-up',
  );

  // 홈(메인)페이지
  static const RouteInfo home = RouteInfo(
    name: '/home',
    path: '/home',
  );

  // 회원 관리
  static const RouteInfo manageUser = RouteInfo(
    name: '/manage-user',
    path: '/manage-user',
  );

  // 선거 관리
  static const RouteInfo manageVote = RouteInfo(
    name: '/manage-vote',
    path: '/manage-vote',
  );
}
