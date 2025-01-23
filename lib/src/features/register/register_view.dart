import 'package:asset_wise_super_app/src/consts/foundation_const.dart';
import 'package:asset_wise_super_app/src/widgets/assetwise_bg.dart';
import 'package:asset_wise_super_app/src/widgets/aw_textfield.dart';
import 'package:asset_wise_super_app/src/features/register/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isMember = false;
  bool _emailForm = false;

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
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
                          _emailForm ? 'กรอก E-mail' : 'กรอกเบอร์มือถือ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _emailForm ? 'ระบุ E-mail ของท่าน เพื่อทำการสมัครสมาชิก' : 'ระบุเบอร์มือถือของท่าน เพื่อทำการสมัครสมาชิก',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isMember = !_isMember;
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                value: _isMember,
                                onChanged: (value) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _isMember = value!;
                                  });
                                },
                              ),
                              Text(
                                'เป็นลูกบ้าน',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: _emailForm,
                          onChanged: (value) {
                            setState(() {
                              _emailForm = value;
                            });
                          },
                          title: Text('เข้าสู่ระบบผ่าน E-mail'),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _emailForm ? _buildEmailForm() : _buildMobileForm(),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pushNamed(context, OtpView.routeName);
                              },
                              child: Text('ถัดไป'),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMobileForm() {
    return Column(children: [
      AwTextField(
        controller: _mobileController,
        label: 'เบอร์มือถือ',
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      SizedBox(
        height: 24,
      ),
      AwTextField(
        controller: _idCardController,
        label: 'เลขบัตรประชาชน 4 ตัวหลัง',
        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 4,
      ),
    ]);
  }

  Widget _buildEmailForm() {
    return Column(children: [
      AwTextField(
        controller: _emailController,
        label: 'E-mail',
        keyboardType: TextInputType.emailAddress,
      ),
    ]);
  }
}
