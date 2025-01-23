import 'package:asset_wise_super_app/src/features/dashboard/widgets/suggest_assets/widgets/suggest_item.dart';
import 'package:flutter/material.dart';

class SuggestAssets extends StatefulWidget {
  const SuggestAssets({super.key});

  @override
  State<SuggestAssets> createState() => _SuggestAssetsState();
}

class _SuggestAssetsState extends State<SuggestAssets> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return const SuggestItem();
        },
        itemCount: 15,
      ),
    );
  }
}
