import 'package:flutter/material.dart';
import 'package:siaganusa/widgets/empty_widget.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.cloud_off_outlined,
      title: 'Data belum bisa dimuat',
      message: message,
      actionLabel: 'Coba lagi',
      onAction: onRetry,
    );
  }
}
