import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetWiseLogo extends StatelessWidget {
  final bool isWideLogo;
  final double? width;
  final double? height;
  final Color? color;
  const AssetWiseLogo({
    super.key,
    this.width,
    this.height,
    this.color,
    this.isWideLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      width: width,
      height: height,
      isWideLogo ? 'assets/images/1200x129_navy.svg' : 'assets/images/1200x1200_navy.svg',
      colorFilter: ColorFilter.mode(
        color ?? (Theme.of(context).brightness == Brightness.dark ? mDarkBodyTextColor : mLightBodyTextColor),
        BlendMode.srcIn,
      ),
      alignment: Alignment.center,
      fit: BoxFit.contain,
    );
  }
}
