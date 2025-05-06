import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PinWidget extends StatelessWidget {
  const PinWidget({
    super.key,
    this.bytes,
    this.imageUrl,
    required this.color,
  });
  final Uint8List? bytes;
  final String? imageUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/icons/pin.svg',
          width: 32,
          height: 40,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        if (imageUrl != null || (bytes != null && bytes!.isNotEmpty))
          // ignore: prefer_const_constructors
          Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Container(
                // margin: const EdgeInsets.only(left: 1),
                padding: const EdgeInsets.all(4),
                width: 24,
                height: 24,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: bytes != null && bytes!.isNotEmpty
                    ? Image.memory(
                        bytes!,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.contain,
                      ),
              )),
      ],
    );
  }
}
