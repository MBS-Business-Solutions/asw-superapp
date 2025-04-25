import 'package:AssetWise/src/features/dashboard/widgets/suggest_assets/widgets/suggest_item.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestAssets extends StatelessWidget {
  const SuggestAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final projects = provider.suggestProjects;
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
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProjectDetailView.routeName, arguments: {'projectId': projects[index].id});
                },
                child: SuggestItem(project: projects[index]),
              );
            },
            itemCount: projects.length,
          ),
        );
      },
    );
  }
}
