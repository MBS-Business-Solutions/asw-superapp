import 'package:asset_wise_super_app/src/consts/colors_const.dart';
import 'package:asset_wise_super_app/src/theme_extensions/hotmenu_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotMenuWidget extends StatelessWidget {
  const HotMenuWidget({
    super.key,
    required this.titleText,
    required this.iconAsset,
  });

  final String titleText;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<HotMenuTheme>();
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: theme?.borderColor ?? Colors.white10),
            gradient: theme?.backgroundGradient ??
                const LinearGradient(
                  colors: [Color.fromARGB(255, 56, 56, 56), Color.fromRGBO(39, 39, 39, 1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
            boxShadow: theme?.boxShadow ??
                const [
                  BoxShadow(
                    color: Color(0x40AAAAAA),
                    spreadRadius: 0,
                    blurRadius: 12.6,
                    offset: Offset(0, 0),
                  ),
                ],
          ),
          child: SvgPicture.asset(
            iconAsset,
            colorFilter: ColorFilter.mode(
              theme?.iconColor ?? mPrimaryMatColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          titleText,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: theme?.textColor ?? Colors.white,
              ),
        )
      ],
    );
  }
}
