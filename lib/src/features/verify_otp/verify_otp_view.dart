import 'dart:async';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/otp_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class VerifyOTPView extends StatefulWidget {
  const VerifyOTPView({super.key, required this.action});
  static const String routeName = '/verify-otp';
  final OTPFor action;
  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  final otpController = TextEditingController();
  late Timer _timer;
  int _start = 60;
  bool _isButtonDisabled = true;
  bool _invalidOTP = false;
  OTPRef? _otpRef;

  @override
  void initState() {
    _otpRef = context.read<VerifyOtpProvider>().otpRef;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (kDebugMode) {
      print(_otpRef?.transId);
    }
    _isButtonDisabled = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start <= 1) {
        setState(() {
          _isButtonDisabled = false;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _otpRequest = context.read<VerifyOtpProvider>().otpRequest;
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
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 32),
                          child: AssetWiseLogo(
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.otpTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (_otpRef != null)
                          Text(
                            AppLocalizations.of(context)!.otpInstruction(
                              _otpRequest!.channel == 'email' ? 'email' : 'mobile',
                              _otpRequest.channel == 'email' ? _otpRequest.email! : StringUtil.phoneFormatter(_otpRequest.phone!),
                              _otpRef!.refCode!,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(
                          height: 4,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextButton.icon(
                          onPressed: _isButtonDisabled ? null : () => _onResendOtp(),
                          label: _isButtonDisabled
                              ? Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: AppLocalizations.of(context)!.otpRequestCountdownPrefix),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                        text: AppLocalizations.of(context)!.otpRequestCountdown(_start),
                                        style: TextStyle(color: mPrimaryMatColor),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(AppLocalizations.of(context)!.otpRequestAgain),
                          icon: const Icon(Icons.refresh),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        OtpInput(
                          controller: otpController,
                          hasError: _invalidOTP,
                          onReset: () {
                            setState(() {
                              _invalidOTP = false;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (_invalidOTP)
                          Text(
                            AppLocalizations.of(context)!.errorInvalidOTP,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mRedColor),
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: () => _verifyOTP(),
                              child: Text(AppLocalizations.of(context)!.actionButtonNext),
                            )),
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

  Future<void> _onResendOtp() async {
    _otpRef = await context.read<VerifyOtpProvider>().resendOTP(action: widget.action);
    if (_otpRef != null) {
      setState(() {
        otpController.text = '';
        _invalidOTP = false;
        _isButtonDisabled = true;
        _start = 60;
      });
      startTimer();
    }
  }

  Future<void> _verifyOTP() async {
    final provider = context.read<VerifyOtpProvider>();
    final response = await provider.verifyOTP(action: widget.action, otp: otpController.text);
    if (mounted) {
      if (response != null) {
        // widget.onOTPVerified?.call(response);
        Navigator.pop(context, true);
      } else {
        setState(() {
          _invalidOTP = true;
        });
      }
    }
  }
}
