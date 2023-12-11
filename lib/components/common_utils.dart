import 'package:offline_pos/components/export_files.dart';

class CommonUtils {
  static bool isTabletMode(BuildContext context) {
    return MediaQuery.of(context).size.width < 1080;
  }

  static Widget appBarActionButtonWithSrcIn(
    String svg, {
    double? width,
    double? height,
    Color? iconColor,
    Function()? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        svg,
        width: width ?? 50,
        height: height ?? 50,
        colorFilter: ColorFilter.mode(
          iconColor ?? Constants.primaryColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  static Widget appBarActionButton(
    String svg, {
    double? width,
    double? height,
    Color? iconColor,
    Function()? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        svg,
        width: width ?? 50,
        height: height ?? 50,
        colorFilter: ColorFilter.mode(
          iconColor ?? Constants.primaryColor,
          BlendMode.srcOut,
        ),
      ),
    );
  }
}
