import 'package:flutter/material.dart';

/// 体重を入力するだけのダイアログ。
///
/// 保存はしない。検証を通った値を `pop` で返し、永続化と状態更新は
/// 呼び出し元の ViewModel（`SettingsScreenViewModel.updateWeight`）が行う。
/// 以前はこのダイアログと ViewModel の両方が saveWeight を呼んでおり、
/// 体重更新のたびに PUT が2回飛んでいた。
class WeightRegistrationDialog extends StatefulWidget {
  final double? currentWeight;

  const WeightRegistrationDialog({
    super.key,
    this.currentWeight,
  });

  @override
  State<WeightRegistrationDialog> createState() =>
      _WeightRegistrationDialogState();
}

class _WeightRegistrationDialogState extends State<WeightRegistrationDialog> {
  final _textController = TextEditingController();

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

  void _submit() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final weight = double.tryParse(text);
    if (weight == null || weight <= 0) {
      _showErrorDialog('有効な体重を入力してください');
      return;
    }

    Navigator.of(context).pop(weight);
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
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('保存'),
        ),
      ],
    );
  }
}
