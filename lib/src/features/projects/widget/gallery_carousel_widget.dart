import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GalleryCarouselWidget extends StatefulWidget {
  const GalleryCarouselWidget({super.key, this.onClose, this.index = 0, required this.imageUrls});
  final Function()? onClose;
  final int index;
  final List<String> imageUrls;
  @override
  State<GalleryCarouselWidget> createState() => _GalleryCarouselWidgetState();
}

class _GalleryCarouselWidgetState extends State<GalleryCarouselWidget> {
  final List<String> _imageUrls = [];

  final _controller = CarouselSliderController();

  @override
  void didUpdateWidget(covariant GalleryCarouselWidget oldWidget) {
    if (oldWidget.imageUrls != widget.imageUrls) {
      setState(() {
        _imageUrls.clear();
        _imageUrls.addAll(widget.imageUrls);
      });
    }
    oldWidget.index != widget.index ? _controller.jumpToPage(widget.index) : null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: GestureDetector(
            onTap: widget.onClose, // ป้องกันไม่ให้ carousel ถูก tap แล้วปิด
            child: Stack(
              children: [
                Positioned.fill(
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: double.infinity,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                    ),
                    itemBuilder: (context, index, realIndex) => GestureDetector(
                      onTap: () {
                        widget.onClose?.call();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(_imageUrls[index], fit: BoxFit.contain, width: MediaQuery.of(context).size.width * 0.7),
                      ),
                    ),
                    itemCount: _imageUrls.length,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton.filled(
                    onPressed: () => _controller.previousPage(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: mGreyColor,
                      size: 32,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filled(
                    onPressed: () => _controller.nextPage(),
                    icon: const Icon(
                      Icons.chevron_right,
                      color: mGreyColor,
                      size: 32,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
