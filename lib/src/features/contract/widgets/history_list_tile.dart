import 'package:flutter/material.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({
    super.key,
    this.trailing,
    required this.title,
    required this.date,
    required this.amount,
  });
  final Widget? trailing;
  final String title;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Color(0xFF585858)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: Text.rich(TextSpan(children: [
          TextSpan(text: title, style: Theme.of(context).textTheme.titleSmall),
          TextSpan(text: ' '),
          TextSpan(text: date, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color(0xFF787878))),
        ])),
        subtitle: Text(amount, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color(0xFF1D9F9B))),
        trailing: trailing,
      ),
    );
  }
}
