import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ThaiQrView extends StatelessWidget {
  const ThaiQrView({super.key, required this.qr});
  static const String routeName = '/thai_qr';
  final String qr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('QR PromptPay'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: double.infinity,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: qr,
                  backgroundColor: Colors.white,
                ),
                Image.asset('assets/images/Thai_QR_Payment_Logo-03.png', width: 70, height: 70),
              ],
            ),
            Text('xxx'),
          ],
        ),
      ),
    );
  }
}
