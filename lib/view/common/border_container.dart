import 'package:flutter/material.dart';
import 'package:offline_pos/components/constant.dart';

class BorderContainer extends StatelessWidget {
  const BorderContainer({
    super.key,
    required this.text,
    this.padding,
    this.textColor,
    this.containerColor,
    this.onTap,
    this.width,
    this.textSize,
    this.radius,
  });
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? containerColor;
  final double? width;
  final double? textSize;
  final double? radius;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: containerColor ?? Constants.primaryColor,
          ),
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: containerColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Constants.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}
