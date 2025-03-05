import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/register/register_otp_view.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isResident = false;
  bool _emailForm = false;
  String? _showError;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                              _emailForm ? AppLocalizations.of(context)!.registerEMail : AppLocalizations.of(context)!.registerMobile,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _emailForm ? AppLocalizations.of(context)!.registerEMailHint : AppLocalizations.of(context)!.registerMobileHint,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _isResident = !_isResident;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isResident,
                                    onChanged: (value) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _isResident = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.registerIsResident,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              value: _emailForm,
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _emailForm = value;
                                });
                              },
                              title: Text(AppLocalizations.of(context)!.registerLoginByEmail),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            _emailForm ? _buildEmailForm() : _buildMobileForm(),
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
        controller: _mobileController,
        label: AppLocalizations.of(context)!.registerMobileLabel,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        validator: (value) => value?.length != 10 ? AppLocalizations.of(context)!.registerInvalidData : null,
      ),
      if (_isResident) ...[
        const SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.registerLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.length != 4 ? AppLocalizations.of(context)!.registerInvalidData : null,
          maxLength: 4,
        ),
      ]
    ]);
  }

  Widget _buildEmailForm() {
    return Column(children: [
      AwTextFormField(
        controller: _emailController,
        label: AppLocalizations.of(context)!.registerEMailLabel,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => !value!.contains('@') ? AppLocalizations.of(context)!.registerInvalidData : null,
      ),
      if (_isResident) ...[
        const SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.registerLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
          validator: (value) => value?.length != 4 ? AppLocalizations.of(context)!.registerInvalidData : null,
        ),
      ]
    ]);
  }

  Future<void> _processToOTPForm() async {
    FocusScope.of(context).unfocus();
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
      final sendTo = _emailForm ? _emailController.text : _mobileController.text;
      if (_isResident) {
        // Validate customer
        bool isValidResident = await AwRegisterService.customerCheck(
          isByMobile: !_emailForm,
          idCard4: _idCardController.text,
          phoneEmail: sendTo,
        );
        if (!isValidResident) {
          // Show error message
          setState(() {
            _showError = AppLocalizations.of(context)!.registerInvalidResident;
          });
        } else {
          final ref = await context.read<RegisterProvider>().requestOTPResident(
                idCard4: _idCardController.text,
                email: _emailController.text,
                phone: _mobileController.text,
                isLoginWithEmail: _emailForm,
              );
          if (ref != null && mounted) {
            _registerProcess();
          } else {
            // Show error message
            setState(() {
              _showError = AppLocalizations.of(context)!.registerError;
            });
          }
        }
      } else {
        final ref = await context.read<RegisterProvider>().requestOTPNonResident(
              email: _emailController.text,
              phone: _mobileController.text,
              isLoginWithEmail: _emailForm,
            );
        if (ref != null && mounted) {
          _registerProcess();
        } else {
          // Show error message
          setState(() {
            _showError = AppLocalizations.of(context)!.registerError;
          });
        }
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
