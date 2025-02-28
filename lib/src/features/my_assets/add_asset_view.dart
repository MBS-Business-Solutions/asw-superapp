import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/widgets/aw_dropdownform.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAssetView extends StatefulWidget {
  const AddAssetView({super.key});

  @override
  State<AddAssetView> createState() => _AddAssetViewState();
}

class _AddAssetViewState extends State<AddAssetView> {
  final _formKey = GlobalKey<FormState>();
  final _invalidProject = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const SizedBox(),
              actions: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เพิ่มบ้าน',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    'ระบุรายละเอียดของคุณสำหรับการเข้าใช้บริการ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: mDefaultPadding),
                  AwDropdownform<String>(
                    itemBuilder: (context, index) => 'project $index',
                    titleBuilder: (context, index) => Text('project $index'),
                    itemCount: 5,
                    label: 'โครงการ *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาระบุโครงการ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mDefaultPadding),
                  AwTextFormField(
                    label: 'บ้านเลขที่ *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาระบุบ้านเลขที่';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mDefaultPadding),
                  AwTextFormField(
                    label: 'รหัสบัตรประชาชน 4 ตัวหลัง *',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 4,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาระบุรหัสบัตรประชาชน 4 ตัวหลัง';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mDefaultPadding),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _submit(), child: const Text('ถัดไป'))),
                ],
              ),
            )),
      ),
    );
  }

  void _submit() async {
    // TODO: Implement submit logic
    if (_formKey.currentState!.validate()) {
      // if (await context.read<VerifyOtpProvider>().requestOTP(phoneEmail: '0832494545') != null) {
      // Process data.
      final otpVerified = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VerifyOTPView(
                    action: OTPFor.other,
                  )));
      // if (otpVerified != null) {
      Navigator.pushReplacementNamed(context, ContractsView.routeName, arguments: {'linkId': 'contract.id'});
      // }
      // }
    }
  }
}
