import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinEntryView extends StatefulWidget {
  const PinEntryView({super.key});
  static const String routeName = '/pin-entry';

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
    isPinEntryVisible = true;

    // TODO: Check iOS can swipe back or not
    return PopScope(
      canPop: false,
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
                  _isInvalidPin ? AppLocalizations.of(context)!.errorInvalidPin : '',
                  style: const TextStyle(color: mRedColor),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.48,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: NumPadWidget(
                    onPressed: (value) {
                      if (pins.length < mPinMaxLength - 1) {
                        setState(() {
                          pins.add(value);
                        });
                      } else if (pins.length <= mPinMaxLength) {
                        pins.add(value);
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
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.pinEntryForget,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    )),
              ],
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

  Future<void> _validatePin() async {
    final userProvider = context.read<UserProvider>();
    final pin = pins.join();
    final isPinValid = await userProvider.validatePin(pin);
    if (isPinValid) {
      isPinEntryVisible = false;
      Navigator.pop(context, true);
    } else {
      setState(() {
        pins.clear();
        _securityDelay = true;
      });
      // Delay for 1 second to simulate security delay
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isInvalidPin = true;
        _securityDelay = false;
      });
    }
  }
}
