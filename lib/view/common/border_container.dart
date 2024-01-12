import 'package:offline_pos/components/export_files.dart';

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
    this.prefixSvg,
    this.suffixSvg,
    this.svgSize,
    this.svgColor,
    this.borderWithPrimaryColor,
  });
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? containerColor;
  final double? width;
  final double? textSize;
  final double? radius;
  final String? prefixSvg;
  final String? suffixSvg;
  final double? svgSize;
  final Color? svgColor;
  final bool? borderWithPrimaryColor;
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
            color: borderWithPrimaryColor == true
                ? primaryColor
                : (containerColor ?? primaryColor),
          ),
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: containerColor,
        ),
        child: prefixSvg != null || suffixSvg != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixSvg != null)
                    CommonUtils.svgIconActionButton(prefixSvg!,
                        width: svgSize, iconColor: svgColor),
                  if (prefixSvg != null) SizedBox(width: 8),
                  _textWidget(),
                  if (suffixSvg != null)
                    CommonUtils.svgIconActionButton(suffixSvg!,
                        width: svgSize, iconColor: svgColor),
                  if (suffixSvg != null) SizedBox(width: 8),
                ],
              )
            : _textWidget(),
      ),
    );
  }

  Align _textWidget() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: textSize,
        ),
      ),
    );
  }
}
