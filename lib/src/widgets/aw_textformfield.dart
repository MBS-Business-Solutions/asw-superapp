import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AwTextFormField extends StatefulWidget {
  const AwTextFormField({
    super.key,
    this.label,
    this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLength,
    this.initialValue,
    this.isEditable = true,
  });
  final String? label;
  final TextEditingController? controller;

  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isEditable;
  final String? initialValue;

  @override
  State<AwTextFormField> createState() => _AwTextFormFieldState();
}

class _AwTextFormFieldState extends State<AwTextFormField> {
  bool _isError = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundTextField : mLightBackgroundTextField,
        borderRadius: BorderRadius.circular(8),
        border: _isError ? Border.all(color: mRedColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label ?? '',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextFormField(
            initialValue: widget.initialValue,
            enabled: widget.isEditable,
            controller: widget.controller,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: mRedColor),
            ),
            keyboardAppearance: Theme.of(context).brightness,
            keyboardType: widget.keyboardType,
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
            buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
            maxLength: widget.maxLength,
          ),
        ],
      ),
    );
  }
}
