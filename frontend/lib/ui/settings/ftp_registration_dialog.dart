import 'package:flutter/material.dart';

/// FTP を入力するだけのダイアログ。
///
/// 保存はしない。検証を通った値を `pop` で返し、永続化と状態更新は
/// 呼び出し元の ViewModel（`SettingsScreenViewModel.updateFtp`）が行う。
/// View にデータアクセスを持たせない規約（docs/architecture.md §2.1）に従う。
class FtpRegistrationDialog extends StatefulWidget {
  final int? currentFtp;

  const FtpRegistrationDialog({
    super.key,
    this.currentFtp,
  });

  @override
  State<FtpRegistrationDialog> createState() => _FtpRegistrationDialogState();
}

class _FtpRegistrationDialogState extends State<FtpRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ftpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentFtp != null) {
      _ftpController.text = widget.currentFtp.toString();
    }
  }

  @override
  void dispose() {
    _ftpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(int.parse(_ftpController.text));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('FTP設定'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Functional Threshold Power (FTP) を設定してください。\n'
              'FTPは20分間の最大平均パワーです。',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ftpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'FTP (W)',
                border: OutlineInputBorder(),
                suffixText: 'W',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'FTPを入力してください';
                }
                final ftp = int.tryParse(value);
                if (ftp == null || ftp <= 0) {
                  return '有効なFTPを入力してください';
                }
                if (ftp > 500) {
                  return 'FTPは500W以下で入力してください';
                }
                return null;
              },
            ),
          ],
        ),
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
