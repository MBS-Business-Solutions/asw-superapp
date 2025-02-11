import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/aw_textfield.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isResident = false;
  bool _emailForm = false;
  bool showError = false;
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
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            _emailForm ? AppLocalizations.of(context)!.registerEMailHint : AppLocalizations.of(context)!.registerMobileHint,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
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
                                Checkbox.adaptive(
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
                                _emailForm = value;
                              });
                            },
                            title: Text(AppLocalizations.of(context)!.registerLoginByEmail),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _emailForm ? _buildEmailForm() : _buildMobileForm(),
                          SizedBox(
                            height: 8,
                          ),
                          if (showError)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.registerInvalidResident,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ))
                              ],
                            ),
                          SizedBox(
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
                                child: Text(AppLocalizations.of(context)!.registerNext),
                              )),
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
      ),
      if (_isResident) ...[
        SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.registerLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
        ),
      ]
    ]);
  }

  Widget _buildEmailForm() {
    return Column(children: [
      AwTextField(
        controller: _emailController,
        label: AppLocalizations.of(context)!.registerEMailLabel,
        keyboardType: TextInputType.emailAddress,
      ),
      if (_isResident) ...[
        SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.registerLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
        ),
      ]
    ]);
  }

  Future<void> _processToOTPForm() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.validate();
    if (_emailForm) {
      // ส่ง OTP ไปที่ E-mail
    } else {
      if (_isResident) {
        // Validate customer
        bool isValidResident = await AwRegisterService.customerCheck(
          isByMobile: true,
          idCard4: _idCardController.text,
          phoneEmail: _mobileController.text,
        );
        if (!isValidResident) {
          // Show error message
          setState(() {
            showError = true;
          });
        }

        // Navigator.of(context).pushNamed('/otp', arguments: {
        //   'phone': _mobileController.text,
        //   'idCard4': _idCardController.text,
        // });
        // ส่ง OTP ไปที่เบอร์มือถือ
      } else {
        // Non-resident login
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
