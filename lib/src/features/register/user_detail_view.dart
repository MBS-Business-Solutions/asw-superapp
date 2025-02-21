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

class RegisterUserDetailView extends StatefulWidget {
  const RegisterUserDetailView({super.key});
  static const String routeName = '/register-detail';

  @override
  State<RegisterUserDetailView> createState() => _RegisterUserDetailViewState();
}

class _RegisterUserDetailViewState extends State<RegisterUserDetailView> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    final registerProvider = context.read<RegisterProvider>();
    final verifyOTPResponse = registerProvider.verifyOTPResponse;
    if (verifyOTPResponse != null) {
      firstNameController.text = verifyOTPResponse.firstName ?? '';
      lastNameController.text = verifyOTPResponse.lastName ?? '';
      phoneController.text = verifyOTPResponse.phone ?? '';
      emailController.text = verifyOTPResponse.email ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.read<RegisterProvider>();
    final verifyOTPResponse = registerProvider.verifyOTPResponse;
    final isEditable = !registerProvider.isResident;
    final isLoginWithEmail = registerProvider.isLoginWithEmail;

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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
                          Text(
                            AppLocalizations.of(context)!.userDetailTitle,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            AppLocalizations.of(context)!.userDetailInstruction,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AwTextFormField(
                              controller: firstNameController,
                              isEditable: isEditable,
                              label: AppLocalizations.of(context)!.userDetailFirstName,
                              validator: (value) {
                                if (value!.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                  return AppLocalizations.of(context)!.userDetailInvalidFirstName;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AwTextFormField(
                              controller: lastNameController,
                              isEditable: isEditable,
                              label: AppLocalizations.of(context)!.userDetailLastName,
                              validator: (value) {
                                if (value!.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                  return AppLocalizations.of(context)!.userDetailInvalidLastName;
                                }
                                return null;
                              },
                            ),
                          ),
                          if (isLoginWithEmail)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AwTextFormField(
                                controller: phoneController,
                                isEditable: isEditable,
                                label: AppLocalizations.of(context)!.userDetailMobile,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 10) {
                                    return AppLocalizations.of(context)!.userDetailInvalidPhone;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (!isLoginWithEmail)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AwTextFormField(
                                controller: emailController,
                                isEditable: isEditable,
                                label: AppLocalizations.of(context)!.userDetailEmail,
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  if (value!.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return AppLocalizations.of(context)!.userDetailInvalidEmail;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (registerProvider.isResident)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AwTextFormField(
                                initialValue: verifyOTPResponse?.idCard,
                                isEditable: isEditable,
                                label: AppLocalizations.of(context)!.userDetailCitizenId,
                              ),
                            ),
                          const SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openConsentPage(BuildContext context) async {
    final registerProvider = context.read<RegisterProvider>();
    if (!registerProvider.isResident) {
      if (_formKey.currentState!.validate()) {
        final loginResult = await context.read<UserProvider>().loginNewUser(
              type: registerProvider.isLoginWithEmail ? 'email' : 'phone',
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phone: phoneController.text,
              email: emailController.text,
            );
        if (loginResult) {
          Navigator.of(context).pushReplacementNamed(ConsentsView.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.errorUnableToProcess),
          ));
        }
      }
    } else {
      if (registerProvider.verifyOTPResponse != null) {
        final userId = registerProvider.verifyOTPResponse!.id!;
        if (await context.read<UserProvider>().login(userId)) {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(ConsentsView.routeName);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.errorNoData),
            ));
          }
        }
      }
    }
  }
}
