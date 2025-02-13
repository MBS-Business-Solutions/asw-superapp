import 'dart:async';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/otp_input.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});
  static const String routeName = '/otp';

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final otpController = TextEditingController();
  OTPRef? refCode;
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
    _start = 10;
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
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          AppLocalizations.of(context)!.otpInstruction(refCode!.isLoginWithEmail ? 'email' : 'mobile', StringUtil.phoneFormatter(refCode!.sendTo), refCode!.refCode),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextButton.icon(
                          onPressed: _isButtonDisabled ? null : () => _onResendOtp(),
                          label: Text(
                            _isButtonDisabled ? AppLocalizations.of(context)!.otpRequestCountdown(_start) : AppLocalizations.of(context)!.otpRequestAgain,
                          ),
                          icon: Icon(Icons.refresh),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        OtpInput(
                          controller: otpController,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        if (_invalidOTP)
                          Text(
                            'หมายเลข OTP ไม่ถูกต้อง',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mRedColor),
                          ),
                        SizedBox(
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
    refCode = await context.read<RegisterProvider>().requestOTPResident();
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
    final response = await context.read<RegisterProvider>().verifyOTPResident(otpController.text);
    if (mounted) {
      if (response != null) {
        Navigator.pushReplacementNamed(context, RegisterUserDetailView.routeName);
      } else {
        setState(() {
          _invalidOTP = true;
        });
      }
    }
  }
}
