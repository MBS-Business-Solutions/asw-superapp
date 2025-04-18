import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';

class CheckOutlineButton extends StatefulWidget {
  const CheckOutlineButton({
    super.key,
    required this.value,
    required this.title,
    this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CheckOutlineButton> createState() => _CheckOutlineButtonState();
}

class _CheckOutlineButtonState extends State<CheckOutlineButton> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  @override
  didUpdateWidget(CheckOutlineButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        isChecked = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isChecked ? mPrimaryMatColor : CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightBodyTextColor);
    final backgroundColor = isChecked ? null : CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightCardBackgroundColor);
    final borderColor = isChecked ? mPrimaryMatColor : null;
    final iconColor = isChecked ? mPrimaryMatColor : CommonUtil.colorTheme(context, darkColor: mLightBorderTextFieldColor, lightColor: mLightBorderTextFieldColor);

    return OutlinedButton.icon(
      onPressed: () => _onChanged(!isChecked),
      icon: isChecked
          ? Icon(
              Icons.check,
              size: 16,
              color: iconColor,
            )
          : null,
      label: Text(
        widget.title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor,
            ),
      ),
      style: OutlinedButton.styleFrom(
        side: isChecked
            ? BorderSide(
                color: borderColor!,
              )
            : null,
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
      ),
    );
  }

  void _onChanged(bool value) {
    setState(() {
      isChecked = value;
    });
    widget.onChanged?.call(value);
  }
}
