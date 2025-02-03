// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/layouts/main_layout.dart';

class CandidateManageView extends ConsumerStatefulWidget {
  const CandidateManageView({super.key});

  @override
  ConsumerState<CandidateManageView> createState() =>
      _CandidateManageViewState();
}

class _CandidateManageViewState extends ConsumerState<CandidateManageView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCollege;
  String? _selectedDepartment;
  String? _noticeImageUrl;
  String? _logoImageUrl;
  PlatformFile? _noticeImage;
  PlatformFile? _logoImage;

  // 대학 목록
  final List<String> _colleges = <String>[
    '인문대학',
    '사회과학대학',
    '경영대학',
    '법과대학',
    'ICT융합대학',
    '미래융합대학',
  ];

  // 대학별 학과 목록
  final Map<String, List<String>> _departments = <String, List<String>>{
    '인문대학': <String>[
      '국어국문학과',
      '중어중문학과',
      '일어일문학과',
      '영어영문학과',
      '사학과',
      '문헌정보학과',
      '아랍지역학과',
      '미술사학과',
      '철학과'
    ],
    '사회과학대학': <String>['행정학과', '경제학과', '정치외교학과', '디지털미디어학과', '아동학과', '청소년지도학과'],
    '경영대학': <String>['경영학과', '국제통상학과', '부동산학과'],
    '법과대학': <String>['법학과'],
    'ICT융합대학': <String>['디지털콘텐츠디자인학과', '융합소프트웨어학부'],
    '미래융합대학': <String>[
      '창의융합인재학부',
      '사회복지학과',
      '부동산학과',
      '법무행정학과',
      '심리치료학과',
      '미래융합경영학과',
      '멀티디자인학과'
    ],
  };

  // 초기 상태 추가
  bool isInitialState = true;
  bool hasRegisteredCandidate = false;
  bool isEditing = false;
  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    if (_noticeImageUrl != null) {
      html.Url.revokeObjectUrl(_noticeImageUrl!);
    }
    if (_logoImageUrl != null) {
      html.Url.revokeObjectUrl(_logoImageUrl!);
    }
    super.dispose();
  }

  Future<void> _pickImage(bool isNoticeImage) async {
    try {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..multiple = false;

      input.click();

      await input.onChange.first;

      if (input.files != null && input.files!.isNotEmpty) {
        final html.File file = input.files!.first;
        setState(() {
          if (isNoticeImage) {
            if (_noticeImageUrl != null) {
              html.Url.revokeObjectUrl(_noticeImageUrl!);
            }
            _noticeImage = PlatformFile(
              name: file.name,
              size: file.size,
            );
            _noticeImageUrl = html.Url.createObjectUrl(file);
          } else {
            if (_logoImageUrl != null) {
              html.Url.revokeObjectUrl(_logoImageUrl!);
            }
            _logoImage = PlatformFile(
              name: file.name,
              size: file.size,
            );
            _logoImageUrl = html.Url.createObjectUrl(file);
          }
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => MainLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '후보자 정보 관리',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: MediaQuery.of(context).size.width >= 800
                              ? 24
                              : 20,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (isInitialState) ...<Widget>[
                    _buildInitialState(),
                  ] else if (hasRegisteredCandidate && !isEditing) ...<Widget>[
                    _buildRegisteredInfo(),
                  ] else ...<Widget>[
                    _buildRegistrationForm(),
                  ],
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildInitialState() => Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '등록된 후보자 정보가 없습니다',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '새로운 후보자 정보를 등록해주세요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: () {
                    setState(() {
                      isInitialState = false;
                      hasRegisteredCandidate = false;
                    });
                  },
                  child: const Text('후보자 정보 등록하기'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRegisteredInfo() => Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '등록된 후보자 정보',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: MediaQuery.of(context).size.width >= 800
                              ? 24
                              : 20,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('후보자 정보 수정'),
                          content: const Text('후보자 정보를 수정하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                  hasRegisteredCandidate = false;
                                  // TODO: 기존 정보를 폼에 채우는 로직 추가
                                  _numberController.text = '1';
                                  _nameController.text = '미래로 나아가는 선거본부';
                                  _selectedCollege = 'ICT융합대학';
                                  _selectedDepartment = '융합소프트웨어학부';
                                  _descriptionController.text =
                                      '우리는 더 나은 미래를 위해 노력하겠습니다. 학생들의 목소리에 귀 기울이고, 실질적인 변화를 이끌어내겠습니다.';
                                  // 이미지는 이미 state에 있음
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('수정'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildInfoField('선거 기호', '1'),
                        const SizedBox(height: 16),
                        _buildInfoField('선거 본부 이름', '미래로 나아가는 선거본부'),
                        const SizedBox(height: 16),
                        _buildInfoField('소속', 'ICT융합대학 융합소프트웨어학부'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '선거 본부 설명',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '우리는 더 나은 미래를 위해 노력하겠습니다. 학생들의 목소리에 귀 기울이고, 실질적인 변화를 이끌어내겠습니다.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '입후보자 공고 이미지',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_noticeImageUrl != null)
                Image.network(
                  _noticeImageUrl!,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 24),
              Text(
                '로고 이미지',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_logoImageUrl != null)
                Image.network(
                  _logoImageUrl!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      );

  Widget _buildInfoField(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );

  Widget _buildRegistrationForm() => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              isEditing ? '후보자 정보 수정' : '후보자 정보 등록',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.width >= 800 ? 24 : 20,
                  ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: '선거 기호',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '선거 기호를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '선거 본부 이름',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '선거 본부 이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (MediaQuery.of(context).size.width >= 800)
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildCollegeDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDepartmentDropdown(),
                  ),
                ],
              )
            else
              Column(
                children: <Widget>[
                  _buildCollegeDropdown(),
                  const SizedBox(height: 16),
                  _buildDepartmentDropdown(),
                ],
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '선거 본부 설명',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '선거 본부 설명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              '입후보자 공고 이미지',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildImageField(
              isNoticeImage: true,
              imageUrl: _noticeImageUrl,
            ),
            const SizedBox(height: 24),
            Text(
              '로고 이미지',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildImageField(
              isNoticeImage: false,
              imageUrl: _logoImageUrl,
              isSquare: true,
            ),
            const SizedBox(height: 32),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isEditing) {
                          isEditing = false;
                          hasRegisteredCandidate = true;
                        } else {
                          isInitialState = true;
                        }
                        // 컨트롤러들 초기화
                        _numberController.clear();
                        _nameController.clear();
                        _descriptionController.clear();
                        _selectedCollege = null;
                        _selectedDepartment = null;
                      });
                    },
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_noticeImageUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('입후보자 공고 이미지를 등록해주세요')),
                          );
                          return;
                        }
                        if (_logoImageUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('로고 이미지를 등록해주세요')),
                          );
                          return;
                        }
                        // TODO: 후보자 정보 등록/수정 로직 구현
                        setState(() {
                          isInitialState = false;
                          hasRegisteredCandidate = true;
                          isEditing = false;
                        });
                      }
                    },
                    child: Text(isEditing ? '수정하기' : '등록하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildImageField({
    required bool isNoticeImage,
    String? imageUrl,
    bool isSquare = false,
  }) {
    const double width = 150.0;
    final double height = isSquare ? width : width * 1.414;

    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageUrl == null
              ? InkWell(
                  onTap: () => _pickImage(isNoticeImage),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 40),
                      SizedBox(height: 8),
                      Text('이미지 추가'),
                    ],
                  ),
                )
              : Stack(
                  children: <Widget>[
                    Image.network(
                      imageUrl,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isNoticeImage) {
                              html.Url.revokeObjectUrl(_noticeImageUrl!);
                              _noticeImageUrl = null;
                              _noticeImage = null;
                            } else {
                              html.Url.revokeObjectUrl(_logoImageUrl!);
                              _logoImageUrl = null;
                              _logoImage = null;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildCollegeDropdown() => DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: '소속 대학',
          border: OutlineInputBorder(),
        ),
        value: _selectedCollege,
        items: _colleges
            .map((String college) => DropdownMenuItem<String>(
                  value: college,
                  child: Text(college),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCollege = newValue;
            _selectedDepartment = null;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '소속 대학을 선택해주세요';
          }
          return null;
        },
      );

  Widget _buildDepartmentDropdown() => DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: '소속 학과',
          border: OutlineInputBorder(),
        ),
        value: _selectedDepartment,
        items: _selectedCollege != null
            ? _departments[_selectedCollege]!
                .map((String department) => DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    ))
                .toList()
            : <DropdownMenuItem<String>>[],
        onChanged: _selectedCollege != null
            ? (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                });
              }
            : null,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '소속 학과를 선택해주세요';
          }
          return null;
        },
      );
}
