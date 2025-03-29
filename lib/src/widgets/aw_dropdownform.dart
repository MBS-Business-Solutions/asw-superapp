import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';

class AwDropdownform<T> extends StatefulWidget {
  const AwDropdownform({
    super.key,
    this.isEditable = true,
    this.initialValue,
    this.validator,
    this.label,
    required this.itemBuilder,
    required this.titleBuilder,
    this.onChanged,
    this.itemCount = 0,
  });
  final String? label;
  final bool isEditable;
  final String? initialValue;
  final String? Function(dynamic value)? validator;
  final T Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) titleBuilder;
  final ValueChanged<T?>? onChanged;
  final int itemCount;

  @override
  State<AwDropdownform> createState() => _AwDropdownformState();
}

class _AwDropdownformState<T> extends State<AwDropdownform> {
  bool _isError = false;
  final List<T> _items = [];
  final List<Widget> _titles = [];
  @override
  void initState() {
    _items.clear();
    _titles.clear();
    for (var index = 0; index < widget.itemCount; index++) {
      _items.add(widget.itemBuilder(context, index));
      _titles.add(widget.titleBuilder(context, index));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonUtil.dismissKeyboard(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundTextField : mLightBackgroundTextField,
          borderRadius: BorderRadius.circular(8),
          border: _isError ? Border.all(color: mRedColor) : null,
        ),
        child: Stack(
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            DropdownButtonFormField<T>(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: mDefaultPadding), // ปรับ padding
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: mRedColor),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              style: Theme.of(context).textTheme.labelMedium,
              items: _buildItems(),
              onChanged: (T? newValue) => widget.onChanged?.call(newValue),
              validator: (value) {
                final res = widget.validator?.call(value);
                if (res != null) {
                  setState(() {
                    _isError = true;
                  });
                } else {
                  setState(() {
                    _isError = false;
                  });
                }
                return res;
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>> _buildItems() {
    List<DropdownMenuItem<T>> items = [];
    for (var index = 0; index < widget.itemCount; index++) {
      items.add(DropdownMenuItem<T>(
        value: widget.itemBuilder(context, index),
        child: widget.titleBuilder(context, index),
      ));
    }
    return items;
  }
}
