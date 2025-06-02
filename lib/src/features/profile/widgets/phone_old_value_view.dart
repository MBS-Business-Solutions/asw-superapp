import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/profile/widgets/phone_new_value_view.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class PhoneOldValueView extends StatelessWidget {
  const PhoneOldValueView({super.key});

  @override
  Widget build(BuildContext context) {
    final String oldValue = context.read<UserProvider>().userInformation?.phone ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.phoneOldValueTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.phoneOldValueTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: mMediumPadding),
              Text(AppLocalizations.of(context)!.phoneOldValueInstructions),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
                child: AwTextFormField(
                  label: AppLocalizations.of(context)!.phoneOldValueTextLabel,
                  initialValue: StringUtil.phoneFormatter(oldValue, hiddenChar: 'x'),
                  isEditable: false,
                ),
              ),
              FilledButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneNewValueView(),
                      )),
                  child: Text(AppLocalizations.of(context)!.phoneOldValueAction)),
            ],
          ),
        ),
      ),
    );
  }
}
