import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectItemWidget extends StatelessWidget {
  const ProjectItemWidget({super.key, required this.project, this.showLikeButton = false});
  final ProjectSearchItem project;
  final bool showLikeButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF585858) : const Color(0xFFE0E0E0)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(project.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0, bottom: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      project.status,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightBodyTextColor).withOpacity(0.5),
                          ),
                    ),
                    Text(
                      project.textPrice,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightBodyTextColor).withOpacity(0.5),
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showLikeButton)
            Positioned(
                top: 0,
                right: 0,
                child: LikeButton(
                  value: project.isFavorite,
                  onChanged: (value) => likeChanged(context, value),
                ))
        ],
      ),
    );
  }

  Future<void> likeChanged(BuildContext context, bool value) async {
    await context.read<ProjectProvider>().setFavorite(project.id, value);
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.value,
    this.onChanged,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.value;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        _isLiked = widget.value;
      });
      _controller.forward().then((_) => _controller.reverse());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: IconButton(
        onPressed: () => widget.onChanged?.call(!_isLiked),
        icon: Icon(
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
