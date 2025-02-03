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

  // 선거 공고 관리
  static const RouteInfo manageElectionNotice = RouteInfo(
    name: '/manage-election-notice',
    path: '/manage-election-notice',
  );

  // 투표 분석
  static const RouteInfo voteAnalytics = RouteInfo(
    name: '/vote-analytics',
    path: '/vote-analytics',
  );

  // 후보자 관리
  static const RouteInfo candidateManage = RouteInfo(
    name: '/candidate-manage',
    path: '/candidate-manage',
  );

  // 투표 결과 관리
  static const RouteInfo manageVoteResult = RouteInfo(
    name: '/manage-vote-result',
    path: '/manage-vote-result',
  );
}
