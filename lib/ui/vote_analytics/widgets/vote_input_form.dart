import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/consts/breakpoints.dart';
import '../models/vote_data.dart';
import '../vote_analytics_view_model.dart';

class VoteInputForm extends ConsumerStatefulWidget {
  const VoteInputForm({super.key});

  @override
  ConsumerState<VoteInputForm> createState() => _VoteInputFormState();
}

class _VoteInputFormState extends ConsumerState<VoteInputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _voterCountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _voterCountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= Breakpoints.tablet;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isWideScreen)
                _buildWideScreenLayout()
              else
                _buildMobileLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreenLayout() => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _voterCountController,
                decoration: const InputDecoration(
                  labelText: '투표자 수',
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
                    return '필수 입력';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: FilledButton(
                onPressed: _submitForm,
                child: const Text('추가'),
              ),
            ),
          ],
        ),
      );

  Widget _buildMobileLayout() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlinedButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _voterCountController,
            decoration: const InputDecoration(
              labelText: '투표자 수',
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
                return '필수 입력';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitForm,
            child: const Text('추가'),
          ),
        ],
      );

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final DailyVote dailyVote = DailyVote(
        date: _selectedDate,
        voterCount: int.parse(_voterCountController.text),
      );

      ref.read(voteAnalyticsViewModelProvider.notifier).addDailyVote(dailyVote);

      _voterCountController.clear();
    }
  }
}
