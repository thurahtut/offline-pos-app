import 'package:flutter/material.dart';
import 'package:offline_pos/components/constant.dart';

class BorderContainer extends StatelessWidget {
  const BorderContainer({
    super.key,
    required this.text,
    this.padding,
    this.textColor,
    this.onTap,
  });
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Constants.primaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Constants.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
