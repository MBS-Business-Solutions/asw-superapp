import 'package:AssetWise/src/features/contract/contract_detail_view.dart';
import 'package:AssetWise/src/features/contract/widgets/history_list_tile.dart';
import 'package:flutter/material.dart';

class ContractsView extends StatelessWidget {
  const ContractsView({super.key});
  static const String routeName = '/contracts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/sample.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            )),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: SizedBox()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('12/34', style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                          Text('Esta Rangsit Klong 2', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)),
                        ],
                      ),
                      Expanded(
                          child: Center(
                              child: OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, ContractDetailView.routeName),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(Icons.dock_sharp),
                        label: Text('รายละเอียดสัญญา'),
                      ))),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: (MediaQuery.of(context).size.height * 0.65) + 32,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white10,
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: Color(0xFF585858)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ยอดที่ต้องชำระ', style: Theme.of(context).textTheme.titleMedium),
                              Text('15,460.00 บาท', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ชำระภายใน', style: Theme.of(context).textTheme.bodyMedium),
                              Text('25 ธ.ค. 67', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ตัดผ่านบัญชี', style: Theme.of(context).textTheme.bodyMedium),
                              Text('*1234', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('วันที่ตัดบัญชี', style: Theme.of(context).textTheme.bodyMedium),
                              Text('25 ธ.ค. 67', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          FilledButton(onPressed: () {}, child: Text('ชำระเงิน')),
                          TextButton(
                              onPressed: () => Navigator.pushNamed(context, ContractDetailView.routeName), child: Text('ดูรายละเอียด'), style: TextButton.styleFrom(foregroundColor: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(child: Text('ประวัติการชำระ', style: Theme.of(context).textTheme.titleMedium)),
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(32)),
                              border: Border.all(color: Color(0xFF585858)),
                            ),
                            child: DropdownButton<String>(
                              isDense: true,
                              icon: Icon(Icons.keyboard_arrow_down),
                              style: Theme.of(context).textTheme.labelMedium,
                              underline: SizedBox(),
                              value: '2567',
                              items: <String>['2567', '2566', '2565'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    return HistoryListTile(
                      title: '25 ธ.ค. 2567',
                      date: '15.36 น.',
                      amount: '15,460.00 บาท',
                      trailing: Icon(
                        Icons.receipt_long_sharp,
                        color: Colors.white54,
                      ),
                    );
                  }))
                ],
              )),
        )
      ],
    ));
  }
}
