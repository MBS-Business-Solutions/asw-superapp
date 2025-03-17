import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/profile/widgets/email_new_value_view.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EmailOldValueView extends StatelessWidget {
  const EmailOldValueView({super.key});

  @override
  Widget build(BuildContext context) {
    final String oldValue = context.read<UserProvider>().userInformation?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.emailOldValueTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.emailOldValueTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: mMediumPadding),
              Text(AppLocalizations.of(context)!.emailOldValueInstructions),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
                child: AwTextFormField(
                  label: AppLocalizations.of(context)!.emailOldValueTextLabel,
                  initialValue: StringUtil.markHiddenEmail(oldValue),
                  isEditable: false,
                ),
              ),
              FilledButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailNewValueView(),
                      )),
                  child: Text(AppLocalizations.of(context)!.emailOldValueAction)),
            ],
          ),
        ),
      ),
    );
  }
}
