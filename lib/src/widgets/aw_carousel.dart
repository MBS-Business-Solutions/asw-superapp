import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AWCarousel extends StatefulWidget {
  const AWCarousel({super.key, required this.children, this.autoPlay, this.autoPlayInterval});
  final List<Widget> children;
  final bool? autoPlay;
  final Duration? autoPlayInterval;
  @override
  State<AWCarousel> createState() => _AWCarouselState();
}

class _AWCarouselState extends State<AWCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            autoPlay: widget.autoPlay ?? true,
            autoPlayInterval: widget.autoPlayInterval ?? const Duration(seconds: 4),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.children,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.children.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == entry.key ? 25.0 : 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: CustomPaint(
                  painter: _StadiumIndicatorPainter(color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StadiumIndicatorPainter extends CustomPainter {
  final Color color;
  _StadiumIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
