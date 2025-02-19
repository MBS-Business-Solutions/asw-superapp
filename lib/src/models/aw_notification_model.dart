import 'package:AssetWise/src/utils/common_util.dart';
import 'package:isar/isar.dart';

part 'aw_notification_model.g.dart';

@Collection()
class NotificationItem {
  String id;
  Id get isarId => CommonUtil.fastHash(id);
  String title;
  String message;
  DateTime createAt;
  String group;
  bool isRead = false;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createAt,
    required this.group,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createAt: DateTime.parse(json['create_at'] as String),
      group: 'Payment',
    );
  }
}
