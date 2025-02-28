import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterBuyerRequestView extends StatefulWidget {
  const RegisterBuyerRequestView({super.key});

  @override
  State<RegisterBuyerRequestView> createState() => _RegisterBuyerRequestViewState();
}

class _RegisterBuyerRequestViewState extends State<RegisterBuyerRequestView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idCardController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('ลงทะเบียนผู้ซื้อ'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'ยืนยันตัวตน',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: mMediumPadding),
                Text(
                  'กรุณายืนยันตัวตนด้วยเลขบัตรประชาชนหรือหมายเลข Passport เพื่อยืนยันตัวตนนตัวตน',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: mDefaultPadding),
                AwTextFormField(
                  controller: _idCardController,
                  label: 'เลขบัตรประจำตัวประชาชน / Passport No.',
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'กรุณากรอกเลขบัตรประจำตัวประชาชน / Passport No.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mDefaultPadding),
                FilledButton(
                  onPressed: () => _registerBuyer(),
                  child: Text('ลงทะเบียน'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerBuyer() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // request OTP
      final otpRef = await context.read<VerifyOtpProvider>().requestOTP(sendTo: _idCardController.text, action: OTPFor.validateUser);
      if (otpRef == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorUnableToProcess)));
        return;
      }
      final otpResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerifyOTPView(
            action: OTPFor.validateUser,
          ),
        ),
      );
      if (otpResult ?? false) Navigator.pop(context, otpResult);
    }
  }
}
