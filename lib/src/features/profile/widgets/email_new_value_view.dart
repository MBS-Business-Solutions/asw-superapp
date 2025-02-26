import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/profile/widgets/email_change_success.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EmailNewValueView extends StatefulWidget {
  const EmailNewValueView({super.key});

  @override
  State<EmailNewValueView> createState() => _EmailNewValueViewState();
}

class _EmailNewValueViewState extends State<EmailNewValueView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.emailNewValueTitle),
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
                    AppLocalizations.of(context)!.emailNewValueTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: mMediumPadding),
                  Text(AppLocalizations.of(context)!.emailNewValueInstructions),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
                    child: AwTextFormField(
                      controller: _emailController,
                      label: AppLocalizations.of(context)!.emailNewValueTextLabel,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return AppLocalizations.of(context)!.userDetailInvalidEmail;
                        }
                        return null;
                      },
                    ),
                  ),
                  FilledButton(
                      onPressed: _loading ? null : () => _submit(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)!.emailNewValueAction),
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
      final result = await context.read<UserProvider>().changeEmail(_emailController.text);
      if (result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailChangeSuccess(),
            ));
      } else {
        // TODO: Show error message
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
