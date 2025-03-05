import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OTPRequestView extends StatefulWidget {
  const OTPRequestView({
    super.key,
    this.forAction,
    this.onOTPVerified,
    this.canLoginAsResident = false,
    this.isBackable = true,
    this.isForLogin = false,
    required this.otpFor,
  });
  static const String routeName = '/otp-request';
  final String? forAction;
  final bool canLoginAsResident;
  final bool isBackable;
  final bool isForLogin;
  final OTPFor otpFor;
  final ValueChanged<RegisterOTPVerifyResponse>? onOTPVerified;

  @override
  State<OTPRequestView> createState() => _OTPRequestViewState();
}

class _OTPRequestViewState extends State<OTPRequestView> {
  bool _emailForm = false;
  bool _isResident = false;
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
      child: PopScope(
        canPop: widget.isBackable,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: widget.isBackable ? null : SizedBox(),
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
                                _emailForm ? AppLocalizations.of(context)!.otpRequestEMail : AppLocalizations.of(context)!.otpRequestMobile,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                _emailForm ? AppLocalizations.of(context)!.otpRequestEMailHint(widget.forAction ?? '') : AppLocalizations.of(context)!.otpRequestMobileHint(widget.forAction ?? ''),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              if (widget.canLoginAsResident)
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
                                        AppLocalizations.of(context)!.otpRequestIsResident,
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
                                title: Text(AppLocalizations.of(context)!.otpRequestLoginByEmail),
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
                                            _processToOTPForm(context);
                                          },
                                    child: _isLoading ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.otpRequestNext),
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
      ),
    );
  }

  Widget _buildMobileForm() {
    return Column(children: [
      AwTextFormField(
        controller: _mobileController,
        label: AppLocalizations.of(context)!.otpRequestMobileLabel,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        validator: (value) => value?.length != 10 ? AppLocalizations.of(context)!.otpRequestInvalidData : null,
      ),
      if (_isResident) ...[
        const SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.otpRequestLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.length != 4 ? AppLocalizations.of(context)!.otpRequestInvalidData : null,
          maxLength: 4,
        ),
      ]
    ]);
  }

  Widget _buildEmailForm() {
    return Column(children: [
      AwTextFormField(
        controller: _emailController,
        label: AppLocalizations.of(context)!.otpRequestEMailLabel,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => !value!.contains('@') ? AppLocalizations.of(context)!.otpRequestInvalidData : null,
      ),
      if (_isResident) ...[
        const SizedBox(
          height: 24,
        ),
        AwTextFormField(
          controller: _idCardController,
          label: AppLocalizations.of(context)!.otpRequestLast4Digits,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
          validator: (value) => value?.length != 4 ? AppLocalizations.of(context)!.otpRequestInvalidData : null,
        ),
      ]
    ]);
  }

  Future<void> _processToOTPForm(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
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

      final ref = await ctx.read<VerifyOtpProvider>().requestOTP(
            action: widget.otpFor,
            channel: _emailForm ? OTPChannel.email : OTPChannel.sms,
            sendTo: sendTo,
            isResident: _isResident,
            idCard4: _idCardController.text.isEmpty ? null : _idCardController.text,
          );
      if (ref != null && mounted) {
        if (ref.success == 'success') {
          final otpVerified = await Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) => VerifyOTPView(
                        action: widget.otpFor,
                      )));
          if (otpVerified ?? false) {
            Navigator.pop(ctx, true);
          }
        } else {
          setState(() {
            _showError = ref.message;
          });
        }
      } else {
        // Show error message
        setState(() {
          _showError = AppLocalizations.of(ctx)!.errorUnableToProcess;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
