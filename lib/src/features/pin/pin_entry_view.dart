import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/verify_otp/otp_request_view.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinEntryView extends StatefulWidget {
  const PinEntryView({super.key, this.isBackable, this.onPinVerified});
  static const String routeName = '/pin-entry';
  final bool? isBackable;
  final ValueChanged<bool>? onPinVerified;

  @override
  State<PinEntryView> createState() => _PinEntryViewState();
}

class _PinEntryViewState extends State<PinEntryView> {
  final pins = <String>[];
  bool _isInvalidPin = false;
  bool _securityDelay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isBackable ?? false,
      child: Scaffold(
        body: Stack(children: [
          const AssetWiseBG(),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 64, bottom: 32),
                  child: AssetWiseLogo(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.pinEntryTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of(context)!.pinEntryInstruction(mPinMaxLength),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < mPinMaxLength; i++) ...[
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: i < pins.length ? mBrightPrimaryColor : Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      if (i < mPinMaxLength - 1)
                        const SizedBox(
                          width: 8,
                        ),
                    ]
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _isInvalidPin ? AppLocalizations.of(context)!.errorInvalidPIN : '',
                  style: const TextStyle(color: mRedColor),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.48,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: NumPadWidget(
                    onPressed: (value) {
                      if (pins.length <= mPinMaxLength) {
                        setState(() {
                          pins.add(value);
                        });
                      }
                      if (pins.length == mPinMaxLength) {
                        _validatePin();
                      }
                    },
                    onDelete: () {
                      if (pins.isNotEmpty) {
                        setState(() {
                          pins.removeLast();
                        });
                      }
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      _onForgetPin();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.pinEntryForget,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    )),
              ],
            ),
          ),
          if (widget.isBackable ?? false)
            Positioned(
              right: mScreenEdgeInsetValue,
              top: MediaQuery.of(context).padding.top + 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
          if (_securityDelay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  void _onForgetPin() async {
    // already set pin, change pin
    final otpValidationResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPRequestView(
          forAction: AppLocalizations.of(context)!.otpRequestActionResetPin,
          otpFor: OTPFor.changePin,
        ),
      ),
    );
    if (otpValidationResult as bool? ?? false) {
      // reset pin
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetPinView(
            skipable: false,
          ),
        ),
      );
    }
  }

  Future<void> _validatePin() async {
    final userProvider = context.read<UserProvider>();
    final pin = pins.join();
    final isPinValid = await userProvider.validatePin(pin);

    if (isPinValid) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        pins.clear();
        _securityDelay = true;
      });
      // Delay for 1 second to simulate security delay
      await Future.delayed(const Duration(milliseconds: mPinDelayMS));
      setState(() {
        _isInvalidPin = true;
        _securityDelay = false;
      });
    }
  }
}
