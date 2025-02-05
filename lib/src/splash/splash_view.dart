import 'package:AssetWise/src/features/dashboard/dashboard_view.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    Future.wait([
      Future.delayed(const Duration(seconds: 4)),
      context.read<DashboardProvider>().reload(),
    ]).then((value) {
      Navigator.of(context).pushReplacementNamed(DashboardView.routeName);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AssetWiseLogo(
            width: MediaQuery.of(context).size.width * 0.6,
            isWideLogo: false,
          ),
        ),
      ),
    );
  }
}
