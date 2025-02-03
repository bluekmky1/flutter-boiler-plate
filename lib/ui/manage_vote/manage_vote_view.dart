// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

import '../common/consts/breakpoints.dart';
import '../common/layouts/main_layout.dart';

class ManageVoteView extends ConsumerStatefulWidget {
  const ManageVoteView({super.key});

  @override
  ConsumerState<ManageVoteView> createState() => _ManageVoteViewState();
}

class _ManageVoteViewState extends ConsumerState<ManageVoteView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTimeRange? _electionPeriod;
  final List<PlatformFile> _guideImages = <PlatformFile>[];
  final List<String> _imageUrls = <String>[];
  final ScrollController _scrollController = ScrollController();
  bool _isFormSubmitted = false; // 추가: 폼 제출 시도 여부를 추적

  // TODO: 실제 데이터 모델로 교체
  bool hasActiveElection = false; // 임시로 선거 유무 상태 확인

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    // URL 정리
    for (final String url in _imageUrls) {
      html.Url.revokeObjectUrl(url);
    }
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 365));
    final DateTime lastDate = now.add(const Duration(days: 365 * 2));

    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 500,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '선거 기간 선택',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.range,
                      firstDate: firstDate,
                      lastDate: lastDate,
                    ),
                    value: _electionPeriod != null
                        ? <DateTime>[
                            _electionPeriod!.start,
                            _electionPeriod!.end
                          ]
                        : <DateTime>[],
                    onValueChanged: (List<DateTime> dates) {
                      if (dates.length == 2) {
                        Navigator.pop(
                          context,
                          DateTimeRange(
                            start: dates[0],
                            end: dates[1],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() {
        _electionPeriod = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..multiple = true;

      input.click();

      await input.onChange.first;

      if (input.files != null && input.files!.isNotEmpty) {
        final List<html.File> files = input.files!;
        setState(() {
          for (final html.File file in files) {
            _guideImages.add(PlatformFile(
              name: file.name,
              size: file.size,
            ));
            // URL 생성 및 저장
            final String url = html.Url.createObjectUrl(file);
            _imageUrls.add(url);
          }
        });
      }
    } on Exception catch (e) {
      print('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미지 선택 중 오류가 발생했습니다: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth >= Breakpoints.desktop
        ? Breakpoints.desktopContentWidth
        : screenWidth >= Breakpoints.tablet
            ? screenWidth * 0.8
            : Breakpoints.mobileContentWidth;

    return MainLayout(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth >= Breakpoints.desktop
                ? Breakpoints.desktopPadding
                : screenWidth >= Breakpoints.tablet
                    ? Breakpoints.tabletPadding
                    : Breakpoints.mobilePadding,
            vertical: 16,
          ),
          child: SizedBox(
            width: contentWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '선거 관리',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  if (hasActiveElection) ...<Widget>[
                    _buildActiveElection(),
                  ] else ...<Widget>[
                    _buildCreateElectionForm(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateElectionForm() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= Breakpoints.tablet;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '새 선거 생성',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          if (isWideScreen)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildTitleField(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateRangeField(),
                ),
              ],
            )
          else ...<Widget>[
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDateRangeField(),
          ],
          const SizedBox(height: 16),
          _buildDescriptionField(),
          const SizedBox(height: 16),
          _buildGuideField(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isFormSubmitted = true; // 폼 제출 시도를 표시
                });
                if (_formKey.currentState!.validate()) {
                  if (_electionPeriod == null) {
                    return;
                  }
                  // TODO: 선거 생성 로직 구현
                  print('선거명: ${_titleController.text}');
                  print('기간: $_electionPeriod');
                  print('설명: ${_descriptionController.text}');
                }
              },
              child: const Text('선거 생성'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() => TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: '선거명',
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '선거명을 입력해주세요';
          }
          return null;
        },
      );

  Widget _buildDateRangeField() => GestureDetector(
        onTap: _selectDateRange,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: '선거 기간',
            border: const OutlineInputBorder(),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorText: _isFormSubmitted && _electionPeriod == null ? '' : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _electionPeriod == null
                    ? '선거 기간을 선택해주세요'
                    : '${_electionPeriod!.start.toString().split(' ')[0]} ~ ${_electionPeriod!.end.toString().split(' ')[0]}',
                style: TextStyle(
                  color: _isFormSubmitted && _electionPeriod == null
                      ? Colors.red
                      : null,
                ),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      );

  Widget _buildDescriptionField() => TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: '선거 설명',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '선거 설명을 입력해주세요';
          }
          return null;
        },
      );

  Widget _buildGuideField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '투표 안내 이미지',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(Colors.grey[400]),
              thickness: WidgetStateProperty.all(8.0),
              radius: const Radius.circular(4.0),
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 8.0,
              radius: const Radius.circular(4.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    // 이미지 추가 버튼
                    Container(
                      width: 150,
                      height: 150,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: _pickImage,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add_photo_alternate, size: 40),
                            SizedBox(height: 8),
                            Text('이미지 추가'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 선택된 이미지 목록
                    ..._guideImages
                        .asMap()
                        .entries
                        .map((MapEntry<int, PlatformFile> entry) => Stack(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(_imageUrls[entry.key]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 12,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        html.Url.revokeObjectUrl(
                                            _imageUrls[entry.key]);
                                        _imageUrls.removeAt(entry.key);
                                        _guideImages.removeAt(entry.key);
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
                            )),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildActiveElection() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= Breakpoints.tablet;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          screenWidth >= Breakpoints.desktop
              ? 32
              : screenWidth >= Breakpoints.tablet
                  ? 24
                  : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '현재 진행중인 선거',
                  style: textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('선거 삭제'),
                        content: const Text('정말로 이 선거를 삭제하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: 선거 삭제 로직 구현
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isWideScreen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '선거명: 제 1회 학생회장 선거',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '기간: 2024-03-20 ~ 2024-03-22',
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '설명: 2024학년도 학생회장 선거입니다.',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '투표 안내: 학생증을 지참하여 투표소에서 투표해주세요.',
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else ...<Widget>[
              Text(
                '선거명: 제 1회 학생회장 선거',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '기간: 2024-03-20 ~ 2024-03-22',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '설명: 2024학년도 학생회장 선거입니다.',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '투표 안내: 학생증을 지참하여 투표소에서 투표해주세요.',
                style: textTheme.titleMedium,
              ),
            ],
            if (_guideImages.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                '투표 안내 이미지',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _guideImages.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(_imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
