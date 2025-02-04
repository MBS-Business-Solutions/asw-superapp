import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:flutter/material.dart';

class ContractDetailView extends StatelessWidget {
  const ContractDetailView({super.key});
  static const String routeName = '/contract-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียดสัญญา',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundColor : mLightBackgroundColor,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailText(context, label: 'วันที่สัญญา', value: '25 ธ.ค. 67'),
                    _buildDetailText(context, label: 'วันที่ลงนาม', value: '25 ธ.ค. 67'),
                    _buildDetailText(context, label: 'วันที่ประมาณการโอน', value: '25 ธ.ค. 67'),
                    const Divider(
                      color: Colors.white10,
                      thickness: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                      child: Text(
                        'มูลค่าสัญญา',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    _buildDetailText(context, label: 'จอง', value: '6,000'),
                    _buildDetailText(context, label: 'สัญญา', value: '20,000'),
                    _buildDetailText(
                      context,
                      label: 'ดาวน์',
                      additionalWidget: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, DownHistoryView.routeName);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 16,
                                  color: mBrightPrimaryColor,
                                ),
                                SizedBox(width: 4),
                                Text('รายละเอียด',
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                          color: mBrightPrimaryColor,
                                          decorationColor: mBrightPrimaryColor,
                                          decoration: TextDecoration.underline,
                                        )),
                              ],
                            )),
                      ),
                      value: '144,000',
                    ),
                    _buildDetailText(context, label: 'โอนฯ', value: '5,039,300'),
                    const Divider(
                      color: Colors.white10,
                      thickness: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รายการของแถมและส่วนลด',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Text(
                              '\u2022 Air Daikin 12000 BTU x 2 เครื่อง',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          for (var i = 0; i < 15; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                '\u2022 Samsung TV LED 40" x 1 เครื่อง',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 64),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: SafeArea(
                    child: FilledButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('ดาวน์โหลดเอกสารสัญญา'), Icon(Icons.file_download_outlined)],
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, {required String label, Widget? additionalWidget, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if (additionalWidget != null) additionalWidget,
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
