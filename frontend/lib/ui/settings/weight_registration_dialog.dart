import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/di/providers.dart';

class WeightRegistrationDialog extends ConsumerStatefulWidget {
  final double? currentWeight;
  
  const WeightRegistrationDialog({
    super.key,
    this.currentWeight,
  });

  @override
  ConsumerState<WeightRegistrationDialog> createState() => _WeightRegistrationDialogState();
}

class _WeightRegistrationDialogState extends ConsumerState<WeightRegistrationDialog> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentWeight != null) {
      _textController.text = widget.currentWeight!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveWeight() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final weight = double.tryParse(text);
    if (weight == null || weight <= 0) {
      _showErrorDialog('有効な体重を入力してください');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = ref.read(saveUserWeightUseCaseProvider);
      await useCase(weight);
      
      if (mounted) {
        Navigator.of(context).pop(weight);
      }
    } catch (e) {
      _showErrorDialog('体重の保存に失敗しました');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('体重登録'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('パワーウェイトレシオ計算に使用する体重を入力してください'),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '体重 (kg)',
              hintText: '60.0',
              border: OutlineInputBorder(),
            ),
            enabled: !_isLoading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveWeight,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
        ),
      ],
    );
  }
}