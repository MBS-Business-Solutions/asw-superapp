import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';

const mScreenEdgeInsetValue = 24.0;
const mDefaultPadding = 16.0;
const mMediumPadding = 8.0;
const mSmallPadding = 4.0;

List<BoxShadow> _mCardShadow(BuildContext context) {
  return [
    BoxShadow(
      color: CommonUtil.colorTheme(context, darkColor: Colors.white.withOpacity(0.2), lightColor: Colors.black.withOpacity(0.1)),
      spreadRadius: 0,
      blurRadius: 5,
      offset: const Offset(0, -1),
    ),
  ];
}

BoxDecoration buildCardDecoration(BuildContext context) {
  return BoxDecoration(
    // Theme dark ขอเป็นสี mDarkBackgroundColor และ light ขอเป็นสี mLightCardBackgroundColor
    color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: mLightCardBackgroundColor),
    border: Border.all(color: CommonUtil.colorTheme(context, darkColor: Color(0xFF585858), lightColor: Colors.transparent)),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
    boxShadow: _mCardShadow(context),
  );
}

BoxDecoration buildItemCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: mLightCardBackgroundColor),
    border: Border.all(color: CommonUtil.colorTheme(context, darkColor: Color(0xFF585858), lightColor: Colors.transparent)),
    borderRadius: BorderRadius.circular(16),
    boxShadow: _mCardShadow(context),
  );
}

BoxDecoration buildBottomCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: (Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor).withOpacity(0.8),
    border: Border.all(
      color: CommonUtil.colorTheme(
        context,
        darkColor: Colors.white.withOpacity(0.2),
        lightColor: Colors.transparent,
      ),
    ),
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    boxShadow: [
      BoxShadow(
        color: CommonUtil.colorTheme(context, darkColor: Colors.transparent, lightColor: Colors.black.withOpacity(0.1)),
        spreadRadius: 0,
        blurRadius: 5,
        offset: const Offset(0, -1),
      ),
    ],
  );
}
