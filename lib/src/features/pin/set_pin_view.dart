import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetPinView extends StatefulWidget {
  const SetPinView({super.key, this.skipable});
  static const String routeName = '/set-pin';
  final bool? skipable;

  @override
  State<SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends State<SetPinView> {
  final pins = <String>[];
  bool _isConfirmState = false;
  bool _isInvalidPin = false;
  bool _showSkip = false;
  String firstPin = '';

  @override
  void initState() {
    _showSkip = widget.skipable ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _isConfirmState ? AppLocalizations.of(context)!.setPinConfirm : AppLocalizations.of(context)!.setPinSetPin(mPinMaxLength),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                AppLocalizations.of(context)!.setPinInstruction(mPinMaxLength),
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
                _isInvalidPin ? AppLocalizations.of(context)!.setPinError : '',
                style: const TextStyle(color: mRedColor),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.48,
                width: MediaQuery.of(context).size.width * 0.8,
                child: NumPadWidget(
                  onPressed: (value) {
                    if (pins.length < mPinMaxLength) {
                      setState(() {
                        pins.add(value);
                        if (pins.length == mPinMaxLength) {
                          if (_isConfirmState) {
                            if (pins.join() == firstPin) {
                              // save pin
                              _setPin(pins.join());
                            } else {
                              pins.clear();
                              _isInvalidPin = true;
                              _isConfirmState = false;
                            }
                          } else {
                            firstPin = pins.join();
                            pins.clear();
                            _isInvalidPin = false;
                            _isConfirmState = true;
                          }
                        }
                      });
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
            ],
          ),
        ),
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
        if (_showSkip)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding, vertical: 8),
              child: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.setPinSkipInstruction,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FilledButton(onPressed: () => _setPin(null), child: Text(AppLocalizations.of(context)!.setPinSkip)),
                ],
              )),
            ),
          )
      ]),
    );
  }

  void _setPin(String? pin) async {
    await context.read<UserProvider>().setPin(pin);
    _processToHome();
  }

  void _processToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
