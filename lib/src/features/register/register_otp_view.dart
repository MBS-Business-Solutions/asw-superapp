import 'dart:async';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/otp_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterVerifyOtpView extends StatefulWidget {
  const RegisterVerifyOtpView({super.key});
  static const String routeName = '/otp';

  @override
  State<RegisterVerifyOtpView> createState() => _RegisterVerifyOtpViewState();
}

class _RegisterVerifyOtpViewState extends State<RegisterVerifyOtpView> {
  final otpController = TextEditingController();
  RegisterOTPRef? refCode;
  late Timer _timer;
  int _start = 60;
  bool _isButtonDisabled = true;
  bool _invalidOTP = false;

  @override
  void initState() {
    super.initState();
    refCode = context.read<RegisterProvider>().otpRef;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (kDebugMode) {
      print(refCode!.transId);
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
                        Text(
                          AppLocalizations.of(context)!.otpInstruction(
                            refCode!.isLoginWithEmail ? 'email' : 'mobile',
                            refCode!.isLoginWithEmail ? refCode!.sendTo : StringUtil.phoneFormatter(refCode!.sendTo),
                            refCode!.refCode,
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
    final registerProvider = context.read<RegisterProvider>();
    if (registerProvider.isResident) {
      refCode = await registerProvider.requestOTPResident();
    } else {
      refCode = await registerProvider.requestOTPNonResident();
    }

    if (refCode != null) {
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
    final registerProvider = context.read<RegisterProvider>();
    RegisterOTPVerifyResponse? response;
    if (registerProvider.isResident) {
      response = await registerProvider.verifyOTPResident(otpController.text);
    } else {
      response = await registerProvider.verifyOTPNonResident(otpController.text);
    }
    if (mounted) {
      if (response != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegisterUserDetailView()), ModalRoute.withName(RegisterView.routeName));
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConsentsView()));
      } else {
        setState(() {
          _invalidOTP = true;
        });
      }
    }
  }
}
