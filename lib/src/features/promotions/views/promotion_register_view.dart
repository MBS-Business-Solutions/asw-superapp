import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_register_done.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromotionRegisterView extends StatelessWidget {
  const PromotionRegisterView({super.key, required this.promotionItemDetail});
  final PromotionItemDetail promotionItemDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(promotionItemDetail.name),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: mScreenEdgeInsetValue),
            child: Column(
              children: [
                AwTextFormField(
                  label: AppLocalizations.of(context)!.promotionsNameField,
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                AwTextFormField(
                  label: AppLocalizations.of(context)!.promotionsLastNameField,
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                AwTextFormField(
                  label: AppLocalizations.of(context)!.promotionsPhoneField,
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                AwTextFormField(
                  label: AppLocalizations.of(context)!.promotionsEmailField,
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundTextField : mLightBackgroundTextField,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.promotionsPriceRange,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundTextField : mLightBackgroundTextField,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.promotionsPurpose,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: mScreenEdgeInsetValue),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _register(context),
                    child: Text(AppLocalizations.of(context)!.promotionsRegister),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) {
    CommonUtil.dismissKeyboard(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PromotionRegisterDone()));
  }
}
