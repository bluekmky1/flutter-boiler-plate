import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../vote_analytics_view_model.dart';

class TotalStudentsSetting extends ConsumerStatefulWidget {
  const TotalStudentsSetting({super.key});

  @override
  ConsumerState<TotalStudentsSetting> createState() =>
      _TotalStudentsSettingState();
}

class _TotalStudentsSettingState extends ConsumerState<TotalStudentsSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int currentTotal =
          ref.read(voteAnalyticsViewModelProvider).totalStudents;
      if (currentTotal > 0) {
        _controller.text = currentTotal.toString();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      // 현재 저장된 값으로 되돌리기
      final int currentTotal =
          ref.read(voteAnalyticsViewModelProvider).totalStudents;
      _controller.text = currentTotal.toString();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(voteAnalyticsViewModelProvider.notifier)
          .setTotalStudents(int.parse(_controller.text));

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('전체 학생 수가 업데이트되었습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalStudents =
        ref.watch(voteAnalyticsViewModelProvider).totalStudents;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.people_outline),
                  const SizedBox(width: 16),
                  const Text('전체 학생 수'),
                  const Spacer(),
                  if (!_isEditing)
                    TextButton.icon(
                      onPressed: _startEditing,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('변경'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isEditing) ...<Widget>[
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '전체 학생 수를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancelEditing,
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submitForm,
                        child: const Text('저장'),
                      ),
                    ),
                  ],
                ),
              ] else
                Text(
                  '$totalStudents명',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
