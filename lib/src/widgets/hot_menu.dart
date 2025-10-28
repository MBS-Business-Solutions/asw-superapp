import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/theme_extensions/hotmenu_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotMenuWidget extends StatelessWidget {
  const HotMenuWidget({
    super.key,
    required this.titleText,
    this.iconAsset,
    this.badgeCount = 0,
    this.highlight = false,
    this.onTap,
    this.isFavMenu = false,
    this.isDisabled = false,
  });

  final String titleText;
  final String? iconAsset;
  final int badgeCount;
  final bool highlight;
  final Function()? onTap;
  final bool isFavMenu;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<HotMenuTheme>();
    return ColorFiltered(
      colorFilter: isDisabled
          ? const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0, // Red channel
              0.2126, 0.7152, 0.0722, 0, 0, // Green channel
              0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
              0, 0, 0, 1, 0, // Alpha channel
            ])
          : const ColorFilter.matrix(<double>[
              1, 0, 0, 0, 0, // Red channel
              0, 1, 0, 0, 0, // Green channel
              0, 0, 1, 0, 0, // Blue channel
              0, 0, 0, 1, 0, // Alpha channel
            ]),
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Column(
          children: [
            Container(
              width: 40 + (isFavMenu ? 24 : 0),
              height: 40 + (isFavMenu ? 24 : 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme?.borderColor ?? Colors.white10),
                gradient: theme?.backgroundGradient ??
                    const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 56, 56, 56),
                        Color.fromRGBO(39, 39, 39, 1)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                boxShadow: isDisabled
                    ? []
                    : (theme?.boxShadow ??
                        const [
                          BoxShadow(
                            color: Color(0x40AAAAAA),
                            spreadRadius: 0,
                            blurRadius: 12.6,
                            offset: Offset(0, 0),
                          ),
                        ]),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : onTap,
                  child: Padding(
                    padding: EdgeInsets.all(isFavMenu ? 20 : 10),
                    child: Badge.count(
                      count: isDisabled ? 0 : badgeCount,
                      isLabelVisible: !isDisabled && badgeCount > 0,
                      child: iconAsset == null
                          ? const SizedBox()
                          : SvgPicture.asset(
                              iconAsset!,
                              colorFilter: ColorFilter.mode(
                                theme?.iconColor ?? mPrimaryMatColor,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (titleText.isNotEmpty)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  titleText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: highlight
                            ? mBrightPrimaryColor
                            : (theme?.textColor ?? Colors.white),
                      ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
