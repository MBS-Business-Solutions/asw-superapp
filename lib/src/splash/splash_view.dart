import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
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
