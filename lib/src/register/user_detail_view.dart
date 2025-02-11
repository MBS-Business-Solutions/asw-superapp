import 'package:asset_wise_super_app/src/0_consts/foundation_const.dart';
import 'package:asset_wise_super_app/src/0_widgets/assetwise_bg.dart';
import 'package:asset_wise_super_app/src/0_widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterUserDetailView extends StatelessWidget {
  const RegisterUserDetailView({super.key});
  static const String routeName = '/register-detail';

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
                        Text(
                          'ระบุชื่อ - นามสกุล',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'ระบุรายละเอียดของคุณสำหรับการเข้าใช้บริการ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            label: 'ชื่อ*',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            label: 'นามสกุล*',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            label: 'เบอร์โทร',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AwTextFormField(
                            label: 'เลขบัตรประจำตัวประชาชน / Passport No.',
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: () {},
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
