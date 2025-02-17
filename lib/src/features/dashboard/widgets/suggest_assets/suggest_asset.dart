import 'package:AssetWise/src/features/dashboard/widgets/suggest_assets/widgets/suggest_item.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/material.dart';

class SuggestAssets extends StatelessWidget {
  const SuggestAssets({super.key, required this.projects});
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    for (final project in projects) {
      precacheImage(NetworkImage(project.image), context);
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return SuggestItem(project: projects[index]);
        },
        itemCount: projects.length,
      ),
    );
  }
}
