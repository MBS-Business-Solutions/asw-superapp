import 'package:AssetWise/src/utils/common_util.dart';
import 'package:isar/isar.dart';

part 'aw_notification_model.g.dart';

class NotificationsResponse {
  List<NotificationItem> items;
  Paging paging;

  NotificationsResponse({
    required this.items,
    required this.paging,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      items: (json['items'] as List<dynamic>).map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList(),
      paging: Paging.fromJson(json['paging'] as Map<String, dynamic>),
    );
  }
}

class Paging {
  int page;
  int rowPerPage;
  int totalItem;
  int totalPage;
  String search;
  String sortBy;
  String sortType;
  String status;
  String cursor;
  int offset;

  Paging({
    required this.page,
    required this.rowPerPage,
    required this.totalItem,
    required this.totalPage,
    required this.search,
    required this.sortBy,
    required this.sortType,
    required this.status,
    required this.cursor,
    required this.offset,
  });

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      page: json['page'] as int,
      rowPerPage: json['row_per_page'] as int,
      totalItem: json['total_item'] as int,
      totalPage: json['total_page'] as int,
      search: json['search'] as String,
      sortBy: json['sort_by'] as String,
      sortType: json['sort_type'] as String,
      status: json['status'] as String,
      cursor: json['cursor'] as String,
      offset: json['offset'] as int,
    );
  }
}

@Collection()
class NotificationItem {
  late String id;
  Id get isarId => CommonUtil.fastHash(id);
  late String titleTh;
  late String titleEn;
  late String messageTh;
  late String messageEn;
  late DateTime createAt;
  String? data;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.titleTh,
    required this.titleEn,
    required this.messageTh,
    required this.messageEn,
    required this.createAt,
    this.data,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      titleTh: json['title_th'] as String,
      titleEn: json['title_en'] as String,
      messageTh: json['message_th'] as String,
      messageEn: json['message_en'] as String,
      createAt: DateTime.parse(json['create_at'] as String),
      data: json['data'] as String?,
    );
  }
}
