// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
// import 'package:go_router/go_router.dart';

import '../../util/date_time_format_helper.dart';
import '../common/consts/breakpoints.dart';
import '../common/layouts/main_layout.dart';
import 'manage_vote_state.dart';
import 'manage_vote_view_model.dart';

class ManageVoteView extends ConsumerStatefulWidget {
  const ManageVoteView({super.key});

  @override
  ConsumerState<ManageVoteView> createState() => _ManageVoteViewState();
}

class _ManageVoteViewState extends ConsumerState<ManageVoteView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePickerPlugin _imagePicker = ImagePickerPlugin();
  DateTimeRange? _electionPeriod;
  final ScrollController _scrollController = ScrollController();
  final bool _isFormSubmitted = false; // 추가: 폼 제출 시도 여부를 추적

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(manageVoteViewModelProvider.notifier).getVoteMetadata();
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    final XFile? image = await _imagePicker.getImageFromSource(
      source: ImageSource.gallery,
    );

    if (image != null) {
      ref
          .read(manageVoteViewModelProvider.notifier)
          .setGuideImage(image: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ManageVoteState state = ref.watch(manageVoteViewModelProvider);
    final ManageVoteViewModel viewModel =
        ref.read(manageVoteViewModelProvider.notifier);

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
                  if (state.isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    Column(
                      children: <Widget>[
                        if (state.isVoteActive) ...<Widget>[
                          _buildActiveElection(
                            state: state,
                            viewModel: viewModel,
                          ),
                        ] else ...<Widget>[
                          _buildCreateElectionForm(
                            state: state,
                            viewModel: viewModel,
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  Widget _buildCreateElectionForm({
    required ManageVoteState state,
    required ManageVoteViewModel viewModel,
  }) {
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
          _buildGuideField(
            state: state,
            viewModel: viewModel,
          ),
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
                if (_formKey.currentState!.validate()) {
                  if (_electionPeriod == null) {
                    return;
                  }
                  viewModel.createVote(
                    voteDateTime: DateTimeFormatter.getDateRangeString(
                      _electionPeriod!.start,
                      _electionPeriod!.end,
                    ),
                    voteDescription: _descriptionController.text,
                    voteName: _titleController.text,
                  );
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
                    : DateTimeFormatter.getDateRangeString(
                        _electionPeriod!.start,
                        _electionPeriod!.end,
                      ),
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

  Widget _buildGuideField({
    required ManageVoteState state,
    required ManageVoteViewModel viewModel,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '투표 안내 이미지',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (state.guideImage.path.isEmpty)
            Container(
              width: 200,
              height: 282,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: selectImage,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_photo_alternate, size: 40),
                    SizedBox(height: 8),
                    Text('이미지 추가'),
                  ],
                ),
              ),
            )
          else
            FutureBuilder<Uint8List>(
              future: state.guideImage.readAsBytes(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 282,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: MemoryImage(snapshot.data!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            viewModel.setGuideImage(image: XFile(''));
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
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
        ],
      );

  Widget _buildActiveElection({
    required ManageVoteState state,
    required ManageVoteViewModel viewModel,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
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
                              viewModel.resetVote();
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
            ...<Widget>[
              Text(
                '선거명: ${state.voteName}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '기간: ${state.voteDateTime}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '설명: ${state.voteDescription}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '투표 안내: ${state.voteDescription}',
                style: textTheme.titleMedium,
              ),
            ],
            if (state.guideImagePath.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                '투표 안내 이미지',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: Image.network(
                  state.guideImagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    print('Image error: $error'); // 에러 확인을 위한 로그
                    return const Center(
                      child: Icon(Icons.error_outline, color: Colors.red),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
