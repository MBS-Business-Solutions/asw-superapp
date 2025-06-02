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
    final activeButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkFilterBackgroundColor, lightColor: Colors.white),
      foregroundColor: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mBrightPrimaryColor),
      textStyle: Theme.of(context).textTheme.labelMedium,
      side: BorderSide(
        color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mBrightPrimaryColor),
      ),
    );
    final inactiveButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkFilterBackgroundColor, lightColor: Colors.white),
      foregroundColor: CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: mDarkGrey),
      textStyle: Theme.of(context).textTheme.labelMedium,
      side: BorderSide(
        color: CommonUtil.colorTheme(context, darkColor: mGreyColor, lightColor: mDarkGrey),
      ),
    );

    return OutlinedButton.icon(
      onPressed: () => _onChanged(!isChecked),
      icon: isChecked
          ? const Icon(
              Icons.check,
              size: 18,
            )
          : null,
      label: Text(
        widget.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: isChecked ? activeButtonStyle : inactiveButtonStyle,
    );
  }

  void _onChanged(bool value) {
    setState(() {
      isChecked = value;
    });
    widget.onChanged?.call(value);
  }
}
