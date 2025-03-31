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
        title: Text(AppLocalizations.of(context)!.registerBuyerTitle),
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
                  AppLocalizations.of(context)!.registerBuyerHeader,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: mMediumPadding),
                Text(
                  AppLocalizations.of(context)!.registerBuyerInstruction,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: mDefaultPadding),
                AwTextFormField(
                  controller: _idCardController,
                  label: AppLocalizations.of(context)!.registerBuyerIdentifier,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return AppLocalizations.of(context)!.errorFieldRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: mDefaultPadding),
                FilledButton(
                  onPressed: () => _registerBuyer(),
                  child: Text(AppLocalizations.of(context)!.registerBuyerRegister),
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
      if (otpRef?.success != 'success' && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(otpRef?.message ?? AppLocalizations.of(context)!.errorUnableToProcess)));
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
