import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: AWContentService().fetchLandingBackgroundURL(),
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
                  child: SvgPicture.asset(
                width: MediaQuery.of(context).size.width * 0.6,
                'assets/images/1200x1200_navy.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                alignment: Alignment.center,
                fit: BoxFit.contain,
              )),
            );
          }),
    );
  }
}
