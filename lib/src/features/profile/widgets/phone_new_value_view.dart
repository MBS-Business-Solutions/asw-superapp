import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/profile/widgets/phone_change_success.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PhoneNewValueView extends StatefulWidget {
  const PhoneNewValueView({super.key});

  @override
  State<PhoneNewValueView> createState() => _PhoneNewValueViewState();
}

class _PhoneNewValueViewState extends State<PhoneNewValueView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.phoneNewValueTitle),
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.phoneNewValueTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: mMediumPadding),
                  Text(AppLocalizations.of(context)!.phoneNewValueInstructions),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
                    child: AwTextFormField(
                      controller: _emailController,
                      label: AppLocalizations.of(context)!.phoneNewValueTextLabel,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10) {
                          return AppLocalizations.of(context)!.userDetailInvalidPhone;
                        }
                        return null;
                      },
                      maxLength: 10,
                    ),
                  ),
                  FilledButton(
                      onPressed: _loading ? null : () => _submit(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)!.phoneNewValueAction),
                          if (_loading) ...[
                            const SizedBox(width: mDefaultPadding),
                            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
                          ],
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      final result = await context.read<UserProvider>().changePhone(_emailController.text);
      if (result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneChangeSuccess(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUnableToProcess),
        ));
      }
      setState(() {
        _loading = false;
      });
    }
  }
}
