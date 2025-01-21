import 'package:flutter/material.dart';

class AssetWiseBG extends StatelessWidget {
  const AssetWiseBG({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Theme.of(context).brightness == Brightness.light ? 'assets/images/AS_Light_BG.png' : 'assets/images/AS_Dark_BG.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
