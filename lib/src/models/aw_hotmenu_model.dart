class HotMenuItem {
  final String id;
  final String titleTextEn;
  final String titleTextTh;
  final String iconAsset;
  final String link;

  HotMenuItem({
    required this.id,
    required this.titleTextEn,
    required this.titleTextTh,
    required this.iconAsset,
    required this.link,
  });

  factory HotMenuItem.fromJson(String id, Map<String, dynamic> json) {
    return HotMenuItem(
      id: id,
      titleTextEn: json['titleText_en'] as String,
      titleTextTh: json['titleText_th'] as String,
      iconAsset: json['iconAsset'] as String,
      link: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titleText_en': titleTextEn,
      'titleText_th': titleTextTh,
      'iconAsset': iconAsset,
      'link': link,
    };
  }
}
