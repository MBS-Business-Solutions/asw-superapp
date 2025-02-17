import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:flutter/material.dart';

class DownHistoryView extends StatelessWidget {
  const DownHistoryView({super.key});
  static const String routeName = '/down-histor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียดงวดดาวน์',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundColor : mLightBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(itemBuilder: (context, index) {
          return const ListTile();
          // return HistoryListTile(
          //   title: 'งวดที่ ${index + 1}',
          //   date: '25 ธ.ค. 2567',
          //   amount: '10,460.00 บาท',
          // );
        }),
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
