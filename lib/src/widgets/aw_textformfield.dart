import 'package:asset_wise_super_app/src/consts/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AwTextFormField extends StatelessWidget {
  const AwTextFormField({
    super.key,
    this.label,
    this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLength,
  });
  final String? label;
  final TextEditingController? controller;

  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundTextField : mLightBackgroundTextField,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label ?? '',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
            keyboardAppearance: Theme.of(context).brightness,
            keyboardType: keyboardType,
            validator: validator,
            buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
            maxLength: maxLength,
          ),
        ],
      ),
    );
  }
}
