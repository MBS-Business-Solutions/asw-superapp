import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';

class FilterOutlineButton extends StatefulWidget {
  const FilterOutlineButton({
    super.key,
    required this.filterStatus,
    this.selectedCode,
    this.onChanged,
  });
  final String? selectedCode;
  final List<ProjectFilterStatus> filterStatus;
  final ValueChanged<String?>? onChanged;

  @override
  State<FilterOutlineButton> createState() => _CheckOutlineButtonState();
}

class _CheckOutlineButtonState extends State<FilterOutlineButton> {
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCode;
  }

  @override
  didUpdateWidget(FilterOutlineButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCode != widget.selectedCode) {
      setState(() {
        _selectedCode = widget.selectedCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: CommonUtil.colorTheme(context, darkColor: Colors.black, lightColor: Colors.white),
      foregroundColor: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mPrimaryMatColor),
      textStyle: Theme.of(context).textTheme.bodyLarge,
      side: BorderSide(
        color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mPrimaryMatColor),
      ),
    );
    final inactiveButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: CommonUtil.colorTheme(context, darkColor: Colors.black, lightColor: Colors.white),
      foregroundColor: mGreyColor,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      side: BorderSide(
        color: CommonUtil.colorTheme(context, darkColor: Colors.transparent, lightColor: Colors.transparent),
      ),
    );

    final defaultButtonWidth = (MediaQuery.of(context).size.width - mScreenEdgeInsetValue * 2 - mMediumPadding * 2) / 3;

    final currentLanguage = Localizations.localeOf(context).languageCode;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: mScreenEdgeInsetValue),
          for (var index = 0; index < widget.filterStatus.length; index++) ...[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: defaultButtonWidth),
              child: OutlinedButton(
                onPressed: () => _onChanged(widget.filterStatus[index].code),
                child: Text(
                  currentLanguage == 'th' ? widget.filterStatus[index].nameTh : widget.filterStatus[index].nameEn,
                ),
                style: ((_selectedCode == null || _selectedCode!.isEmpty) && index == 0) || _selectedCode == widget.filterStatus[index].code ? activeButtonStyle : inactiveButtonStyle,
              ),
            ),
            if (index != widget.filterStatus.length - 1) const SizedBox(width: mMediumPadding),
          ],
          const SizedBox(width: mScreenEdgeInsetValue),
        ],
      ),
    );
  }

  void _onChanged(String? value) {
    setState(() {
      _selectedCode = value;
    });
    widget.onChanged?.call(value);
  }
}
