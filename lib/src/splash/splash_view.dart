import 'package:AssetWise/src/features/dashboard/dashboard_view.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash';

  Future<void> _checkPinIfSet(BuildContext context) async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 4)),
      context.read<DashboardProvider>().reload(),
    ]);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(DashboardView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkPinIfSet(context);

    return Scaffold(
      body: FutureBuilder(
          future: AWContentService.fetchLandingBackgroundURL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              decoration: snapshot.data!.isEmpty
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25),
                          BlendMode.darken,
                        ),
                      ),
                    ),
              child: Center(
                child: AssetWiseLogo(
                  width: MediaQuery.of(context).size.width * 0.6,
                  isWideLogo: false,
                ),
              ),
            );
          }),
    );
  }
}
