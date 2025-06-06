import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/register/register_otp_view.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? _showError;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: IgnorePointer(
          ignoring: _isLoading,
          child: Stack(
            children: [
              const AssetWiseBG(),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 32),
                              child: AssetWiseLogo(
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.registerUserName,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              AppLocalizations.of(context)!.registerUserNameHint,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            _buildMobileForm(),
                            const SizedBox(
                              height: 8,
                            ),
                            if (_showError != null)
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    _showError!,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ))
                                ],
                              ),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: FilledButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          _processToOTPForm();
                                        },
                                  child: _isLoading ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.registerNext),
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileForm() {
    return Column(children: [
      AwTextFormField(
        controller: _userNameController,
        label: AppLocalizations.of(context)!.registerUserNameLabel,
        validator: (value) => (value?.isEmpty ?? true) ? AppLocalizations.of(context)!.registerInvalidData : null,
      ),
    ]);
  }

  Future<void> _processToOTPForm() async {
    CommonUtil.dismissKeyboard(context);
    setState(() {
      _isLoading = true;
      _showError = null;
    });
    try {
      if (!_formKey.currentState!.validate()) {
        setState(() {
          _showError = null;
          _isLoading = false;
        });
        return;
      }
      final ref = await context.read<RegisterProvider>().requestOTPNonResident(
            userName: _userNameController.text,
          );
      if (ref != null && ref.status == 'success' && mounted) {
        _registerProcess();
      } else {
        // Show error message
        setState(() {
          _showError = ref?.message ?? AppLocalizations.of(context)!.registerError;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _registerProcess() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterVerifyOtpView()));
  }
}
