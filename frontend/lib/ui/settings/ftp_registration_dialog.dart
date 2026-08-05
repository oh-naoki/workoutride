import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';

class FtpRegistrationDialog extends ConsumerStatefulWidget {
  const FtpRegistrationDialog({super.key});

  @override
  ConsumerState<FtpRegistrationDialog> createState() =>
      _FtpRegistrationDialogState();
}

class _FtpRegistrationDialogState extends ConsumerState<FtpRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ftpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentFtp();
  }

  @override
  void dispose() {
    _ftpController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentFtp() async {
    final currentFtp = await ref.read(userProfileRepositoryProvider).getFtp();
    if (currentFtp != null) {
      _ftpController.text = currentFtp.toString();
    }
  }

  Future<void> _saveFtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ftp = int.parse(_ftpController.text);
      await ref.read(userProfileRepositoryProvider).saveFtp(ftp);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppException.messageFor(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveFtp,
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
