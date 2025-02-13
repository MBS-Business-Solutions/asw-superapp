import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterUserDetailView extends StatelessWidget {
  const RegisterUserDetailView({super.key});
  static const String routeName = '/register-detail';

  @override
  Widget build(BuildContext context) {
    final verifyOTPResponse = context.read<RegisterProvider>().verifyOTPResponse;
    final isEditable = verifyOTPResponse == null;
    final isLoginWithEmail = context.read<RegisterProvider>().isLoginWithEmail ?? false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            const AssetWiseBG(),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
                        Text(
                          AppLocalizations.of(context)!.userDetailTitle,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          AppLocalizations.of(context)!.userDetailInstruction,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            initialValue: 'xxxxxxxxx',
                            isEditable: isEditable,
                            label: AppLocalizations.of(context)!.userDetailFirstName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            initialValue: 'xxxxxxxxx',
                            isEditable: isEditable,
                            label: AppLocalizations.of(context)!.userDetailLastName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            initialValue: isLoginWithEmail ? verifyOTPResponse?.phone : verifyOTPResponse?.email,
                            isEditable: isEditable,
                            label: isLoginWithEmail ? AppLocalizations.of(context)!.userDetailMobile : AppLocalizations.of(context)!.userDetailEmail,
                            keyboardType: isLoginWithEmail ? TextInputType.phone : TextInputType.emailAddress,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            initialValue: verifyOTPResponse?.idCard,
                            isEditable: isEditable,
                            label: AppLocalizations.of(context)!.userDetailCitizenId,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: () => _openConsentPage(context),
                              child: Text(AppLocalizations.of(context)!.actionButtonNext),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openConsentPage(BuildContext context) async {
    // Navigator.of(context).pushNamed(ConsentsView.routeName);
    if (context.read<RegisterProvider>().verifyOTPResponse != null) {
      final userId = context.read<RegisterProvider>().verifyOTPResponse!.id;
      if (await context.read<UserProvider>().login(userId) && context.mounted) {
        Navigator.of(context).pushNamed(ConsentsView.routeName);
      }
    }
  }
}
