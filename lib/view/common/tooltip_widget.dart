import 'package:flutter/material.dart';

class TooltipWidget extends StatelessWidget {
  const TooltipWidget({super.key, this.message, this.child});
  final String? message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}
