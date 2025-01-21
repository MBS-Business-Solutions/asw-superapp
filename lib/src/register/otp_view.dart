import 'package:asset_wise_super_app/src/0_consts/foundation_const.dart';
import 'package:asset_wise_super_app/src/0_widgets/assetwise_bg.dart';
import 'package:asset_wise_super_app/src/0_widgets/otp_input.dart';
import 'package:asset_wise_super_app/src/register/user_detail_view.dart';
import 'package:flutter/material.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key, this.refCode});
  static const String routeName = '/otp';
  final String? refCode;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Image.asset(
                          'assets/images/assetwise_logo_horz.png',
                          width: MediaQuery.of(context).size.width * 0.6,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'กรอก OTP',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'ระบุตัวเลข 6 หลักที่ถูกส่งไปยังอีเมล\nsample@gmail.com',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Ref Code: ${widget.refCode}',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text('ส่งรหัสยืนยันอีกครั้ง'),
                          icon: Icon(Icons.refresh),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        OtpInput(),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterUserDetailView.routeName);
                              },
                              child: Text('ถัดไป'),
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
}
