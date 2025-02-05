import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/numpad.dart';
import 'package:flutter/material.dart';

class SetPinView extends StatefulWidget {
  const SetPinView({super.key});
  static const String routeName = '/set-pin';

  @override
  State<SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends State<SetPinView> {
  final pinMaxLength = 6;
  final pins = <String>[];
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
                'ตั้งรหัส PIN จำนวน 6 หลัก',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'ระบุรหัส PIN จำนวน 6 หลักเพื่อใช้ในการเข้าสู่ระบบครั้งต่อไป',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pinMaxLength; i++) ...[
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: i < pins.length ? mBrightPrimaryColor : Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    if (i < pinMaxLength - 1)
                      SizedBox(
                        width: 8,
                      ),
                  ]
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: NumPadWidget(
                  onPressed: (value) {
                    if (pins.length < pinMaxLength) {
                      setState(() {
                        pins.add(value);
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
      ]),
    );
  }
}
