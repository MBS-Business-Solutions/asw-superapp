import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
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
  var isPhoneEmpty = false;
  var isEmailEmpty = false;

  @override
  void initState() {
    final registerProvider = context.read<RegisterProvider>();
    final verifyOTPResponse = registerProvider.verifyOTPResponse;
    if (verifyOTPResponse != null) {
      firstNameController.text = verifyOTPResponse.firstName ?? '';
      lastNameController.text = verifyOTPResponse.lastName ?? '';

      phoneController.text = verifyOTPResponse.phone ?? '';
      emailController.text = verifyOTPResponse.email ?? '';

      isPhoneEmpty = phoneController.text.isEmpty;
      isEmailEmpty = emailController.text.isEmpty;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.read<RegisterProvider>();
    final verifyOTPResponse = registerProvider.verifyOTPResponse;
    final isEditable = !registerProvider.isResident;

    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            const AssetWiseBG(),
            Positioned.fill(
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
                                if (value!.isEmpty || RegExp(mNameRegex).hasMatch(value)) {
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
                                if (value!.isEmpty || RegExp(mNameRegex).hasMatch(value)) {
                                  return AppLocalizations.of(context)!.userDetailInvalidLastName;
                                }
                                return null;
                              },
                            ),
                          ),
                          if (registerProvider.isResident || isEditable)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AwTextFormField(
                                controller: phoneController,
                                isEditable: isEditable,
                                label: AppLocalizations.of(context)!.userDetailMobile,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length != 10) {
                                    return AppLocalizations.of(context)!.userDetailInvalidPhone;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          if (registerProvider.isResident || isEditable)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AwTextFormField(
                                controller: emailController,
                                isEditable: isEditable,
                                label: AppLocalizations.of(context)!.userDetailEmail,
                                keyboardType: TextInputType.emailAddress,
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
    bool loginResult = false;
    bool consentGave = false;
    if (!registerProvider.isResident) {
      if (_formKey.currentState!.validate()) {
        if (await context.read<UserProvider>().loginNewUser(
              type: '-',
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phone: phoneController.text,
              email: emailController.text,
            )) {
          // load user info
          consentGave = context.read<UserProvider>().userInformation?.consent ?? false;
          loginResult = true;
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
            loginResult = true;
            consentGave = context.read<UserProvider>().userInformation?.consent ?? false;
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

    if (loginResult) {
      if (!consentGave) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ConsentsView()), ModalRoute.withName(RegisterView.routeName));
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SetPinView()), (route) => route.isFirst);
      }
    }
  }
}
