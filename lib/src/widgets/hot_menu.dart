import 'package:flutter/material.dart';

class HotMenuWidget extends StatelessWidget {
  const HotMenuWidget({
    super.key,
    required this.titleText,
    required this.icon,
  });

  final String titleText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 56, 56, 56), Color.fromRGBO(39, 39, 39, 1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40AAAAAA),
                spreadRadius: 0,
                blurRadius: 12.6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: icon,
        ),
        const SizedBox(height: 8),
        Text(
          titleText,
          style: Theme.of(context).textTheme.labelMedium,
        )
      ],
    );
  }
}
