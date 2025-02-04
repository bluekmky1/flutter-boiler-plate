class Governances {
  static List<GovernanceInfo> governanceList = <GovernanceInfo>[
    GovernanceInfo(
      id: '1',
      governanceName: 'ICT 융합대학',
      governanceType: 'ICT 융합대학',
    ),
    GovernanceInfo(
      id: '2',
      governanceName: '융합소프트웨어학부',
      governanceType: 'ICT 융합대학',
    ),
    GovernanceInfo(
      id: '3',
      governanceName: '총학생회',
      governanceType: '총학생회',
    ),
    GovernanceInfo(
      id: '4',
      governanceName: '디지털콘텐츠디자인학과',
      governanceType: 'ICT 융합대학',
    ),
    GovernanceInfo(
      id: '5',
      governanceName: '전공자유학부(인문)',
      governanceType: '방목기초교육대학',
    ),
    GovernanceInfo(
      id: '6',
      governanceName: '인문대학',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '7',
      governanceName: '국어국문학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '8',
      governanceName: '중어중문학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '9',
      governanceName: '일어일문학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '10',
      governanceName: '영어영문학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '11',
      governanceName: '사학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '12',
      governanceName: '문헌정보학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '13',
      governanceName: '아랍지역학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '14',
      governanceName: '미술사학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '15',
      governanceName: '철학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '16',
      governanceName: '문예창작학과',
      governanceType: '인문대학',
    ),
    GovernanceInfo(
      id: '17',
      governanceName: '사회과학대학',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '18',
      governanceName: '행정학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '19',
      governanceName: '경제학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '20',
      governanceName: '정치외교학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '21',
      governanceName: '디지털미디어학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '22',
      governanceName: '아동학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '23',
      governanceName: '청소년지도학과',
      governanceType: '사회과학대학',
    ),
    GovernanceInfo(
      id: '24',
      governanceName: '경영대학',
      governanceType: '경영대학',
    ),
    GovernanceInfo(
      id: '25',
      governanceName: '경영학과',
      governanceType: '경영대학',
    ),
    GovernanceInfo(
      id: '26',
      governanceName: '국제통상학과',
      governanceType: '경영대학',
    ),
    GovernanceInfo(
      id: '27',
      governanceName: '경영정보학과',
      governanceType: '경영대학',
    ),
    GovernanceInfo(
      id: '28',
      governanceName: '법학과',
      governanceType: '법과대학',
    ),
    GovernanceInfo(
      id: '29',
      governanceName: '법과대학',
      governanceType: '법과대학',
    ),
  ];

  // 단과대학 목록 가져오기
  static List<String> getColleges() {
    final Set<String> colleges = <String>{};
    for (final GovernanceInfo governance in governanceList) {
      colleges.add(governance.governanceType);
    }
    return colleges.toList()..sort();
  }

  // 단과대학별 학과 목록 가져오기
  static List<String> getDepartments(String college) {
    final List<String> departments = <String>[];
    for (final GovernanceInfo governance in governanceList) {
      if (governance.governanceType == college &&
          governance.governanceType != governance.governanceName) {
        departments.add(governance.governanceName);
      }
    }
    return departments..sort();
  }

  // ID로 선거구 정보 가져오기
  static GovernanceInfo getGovernanceById(String id) =>
      governanceList.firstWhere(
        (GovernanceInfo governance) => governance.id == id,
        orElse: () => GovernanceInfo(
          id: '',
          governanceName: '',
          governanceType: '',
        ),
      );

  // 단과대학과 학과명으로 ID 가져오기
  static GovernanceInfo getGovernanceId(String college, String? department) =>
      governanceList.firstWhere(
        (GovernanceInfo governance) => governance.governanceName == college,
        orElse: () => GovernanceInfo(
          id: '',
          governanceName: '',
          governanceType: '',
        ),
      );
}

class GovernanceInfo {
  final String id;
  final String governanceName;
  final String governanceType;

  GovernanceInfo({
    required this.id,
    required this.governanceName,
    required this.governanceType,
  });
}
