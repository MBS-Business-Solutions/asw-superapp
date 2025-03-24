import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownPaymentTermDueTile extends StatefulWidget {
  const DownPaymentTermDueTile({
    super.key,
    required this.termDue,
    this.onTap,
    this.initial = false,
    required this.canChange,
  });
  final DownPaymentTermDue termDue;
  final ValueChanged<bool>? onTap;
  final bool initial;
  final bool Function(DownPaymentTermDue due, bool value) canChange;

  @override
  State<DownPaymentTermDueTile> createState() => _DownPaymentTermDueTileState();
}

class _DownPaymentTermDueTileState extends State<DownPaymentTermDueTile> {
  bool state = false;

  @override
  void initState() {
    state = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: buildItemCardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: mDefaultPadding),
          onTap: () {
            if (widget.canChange(widget.termDue, !state)) _onTap(!state);
          },
          // contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormatterUtil.formatFullDate(context, widget.termDue.dueDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Text(
                widget.termDue.termName,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor)),
              ),
              IgnorePointer(
                child: Checkbox(value: state, onChanged: (value) {}),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.priceFormatBaht(widget.termDue.amount),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: mRedColor,
                            )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(bool value) {
    setState(() {
      state = value;
    });
    widget.onTap?.call(value);
  }
}
