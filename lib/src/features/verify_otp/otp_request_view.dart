import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OTPRequestView extends StatefulWidget {
  const OTPRequestView({super.key, this.forAction, this.onOTPVerified});
  static const String routeName = '/otp-request';
  final String? forAction;
  final ValueChanged<VerifyOTPResponse>? onOTPVerified;

  @override
  State<OTPRequestView> createState() => _OTPRequestViewState();
}

class _OTPRequestViewState extends State<OTPRequestView> {
  bool _emailForm = false;
  String? _showError;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileController = TextEditingController();
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
            channel: _emailForm ? OTPChannel.email : OTPChannel.sms,
            phoneEmail: sendTo,
          );
      if (ref != null && mounted) {
        final otpVerified = await Navigator.push(ctx, MaterialPageRoute(builder: (context) => VerifyOTPView(onOTPVerified: widget.onOTPVerified)));
        if (otpVerified ?? false) {
          Navigator.pop(ctx, true);
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
