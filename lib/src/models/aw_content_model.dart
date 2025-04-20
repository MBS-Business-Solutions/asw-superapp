import 'dart:convert';

class Project {
  final int id;
  final String name;
  final String status;
  final String image;

  Project({required this.id, required this.name, required this.status, required this.image});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name'], status: json['status'], image: json['image']);
  }
}

class ImageContent {
  final String image;
  final int id;

  ImageContent({required this.image, required this.id});

  factory ImageContent.fromJson(Map<String, dynamic> json) {
    return ImageContent(image: json['image'], id: json['id']);
  }
}

class RegisterOTPRef {
  final String status;
  final String? idCard;
  final String? sendTo;
  final String? transId;
  final String? refCode;
  final String? message;
  final String? identifier;

  RegisterOTPRef({
    this.idCard,
    required this.status,
    required this.transId,
    required this.refCode,
    required this.sendTo,
    required this.message,
    required this.identifier,
  });

  factory RegisterOTPRef.fromJson(
    Map<String, dynamic> json, {
    required String status,
    String? idCard,
    required String sendTo,
  }) {
    return RegisterOTPRef(
      status: status,
      transId: json['trans_id'],
      refCode: json['ref_code'],
      identifier: json['identifier'],
      message: json['message'],
      sendTo: sendTo,
      idCard: idCard,
    );
  }
}

class RegisterOTPVerifyResponse {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? idCard;
  final bool? isResident;

  RegisterOTPVerifyResponse({this.id, this.phone, this.firstName, this.lastName, this.email, this.idCard, this.isResident});

  factory RegisterOTPVerifyResponse.fromJson(Map<String, dynamic> json) {
    return RegisterOTPVerifyResponse(
      id: json['id'],
      phone: json['phone'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      idCard: json['id_card'],
      isResident: json['is_resident'],
    );
  }
}

class Consent {
  final String id;
  final String version;
  final String content;
  final List<ConsentItem> items;

  Consent({required this.id, required this.version, required this.content, required this.items});

  factory Consent.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<ConsentItem> items = itemsList.map((i) => ConsentItem.fromJson(i)).toList();

    return Consent(
      id: json['id'],
      version: json['version'],
      content: json['content'],
      items: items,
    );
  }
}

class ConsentItem {
  final String id;
  final String title;
  final String content;
  final bool isRequired;

  ConsentItem({required this.id, required this.title, required this.content, required this.isRequired});

  factory ConsentItem.fromJson(Map<String, dynamic> json) {
    return ConsentItem(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isRequired: json['is_required'],
    );
  }
}

class UserToken {
  final String token;
  final UserInformation userInformation;

  UserToken({required this.token, required this.userInformation});

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(token: json['token'], userInformation: UserInformation.fromJson(json['data']));
  }
}

class UserInformation {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final int? unitCount;
  final String? language;
  final bool? isVerified;
  final bool? consent;
  final String? code;

  UserInformation({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.unitCount,
    required this.language,
    required this.isVerified,
    this.consent,
    this.code,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      unitCount: json['unit_count'],
      language: json['language'],
      isVerified: json['is_verified'],
      consent: json['consent'],
      code: json['code'],
    );
  }

  String toJson() {
    return json.encode({
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'unit_count': unitCount,
      'language': language,
      'is_verified': isVerified,
    });
  }
}

class Unit {
  final String contractId;
  final String projectCode;
  final String unitNumber;
  final String houseNumber;

  Unit({
    required this.contractId,
    required this.projectCode,
    required this.unitNumber,
    required this.houseNumber,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      contractId: json['contract_id'],
      projectCode: json['project_code'],
      unitNumber: json['unit_number'],
      houseNumber: json['house_number'],
    );
  }
}

class PersonalConsent {
  final String id;
  final String name;

  PersonalConsent({required this.id, required this.name});

  factory PersonalConsent.fromJson(Map<String, dynamic> json) {
    return PersonalConsent(
      id: json['id'],
      name: json['name'],
    );
  }
}

class PersonalConsentDetail {
  final String headerName;
  final DateTime updateDate;
  final String content;
  final bool isGiven;

  PersonalConsentDetail({
    required this.headerName,
    required this.updateDate,
    required this.content,
    required this.isGiven,
  });

  factory PersonalConsentDetail.fromJson(Map<String, dynamic> json) {
    return PersonalConsentDetail(
      headerName: json['header_name'],
      updateDate: DateTime.parse(json['update_date']),
      content: json['content'],
      isGiven: json['is_given'],
    );
  }
}

class AboutItem {
  final String id;
  final String name;

  AboutItem({required this.id, required this.name});

  factory AboutItem.fromJson(Map<String, dynamic> json) {
    return AboutItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AboutItemDetail {
  final String headerName;
  final DateTime updateDate;
  final String content;

  AboutItemDetail({
    required this.headerName,
    required this.updateDate,
    required this.content,
  });

  factory AboutItemDetail.fromJson(Map<String, dynamic> json) {
    return AboutItemDetail(
      headerName: json['header_name'],
      updateDate: DateTime.parse(json['update_date']),
      content: json['content'],
    );
  }
}

class PromotionBanner {
  int id;
  String image;

  PromotionBanner({required this.id, required this.image});

  factory PromotionBanner.fromJson(Map<String, dynamic> json) {
    return PromotionBanner(
      id: json['id'],
      image: json['image'],
    );
  }
}

class PromotionItem {
  final int id;
  final String image;
  final String title;
  final String description;

  PromotionItem({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  factory PromotionItem.fromJson(Map<String, dynamic> json) {
    return PromotionItem(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class PromotionItemDetail {
  final int id;
  final String name;
  final DateTime date;
  final String image;
  final String content;
  final String url;

  PromotionItemDetail({
    required this.id,
    required this.name,
    required this.date,
    required this.image,
    required this.content,
    required this.url,
  });

  factory PromotionItemDetail.fromJson(Map<String, dynamic> json) {
    return PromotionItemDetail(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      image: json['image'],
      content: json['content'],
      url: json['url'],
    );
  }
}

class ProjectSearchItem {
  final int id;
  final String name;
  final String image;
  final String status;
  final String textPrice;
  bool isFavorite;

  ProjectSearchItem({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.textPrice,
    required this.isFavorite,
  });

  factory ProjectSearchItem.fromJson(Map<String, dynamic> json) {
    return ProjectSearchItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      textPrice: json['text_price'],
      isFavorite: json['is_favorite'],
    );
  }
}

class ProjectFilterStatus {
  final String code;
  final String nameTh;
  final String nameEn;

  ProjectFilterStatus({
    required this.code,
    required this.nameTh,
    required this.nameEn,
  });

  factory ProjectFilterStatus.fromJson(Map<String, dynamic> json) {
    return ProjectFilterStatus(
      code: json['code'],
      nameTh: json['name_th'],
      nameEn: json['name_en'],
    );
  }
}

class ProjectDetail {
  final int id;
  final ProjectInfo projectInfo;
  final ProjectLocation location;
  final List<FloorPlan> floorPlan;
  final List<GalleryItem> gallery;
  final List<AdvertItem> advert;
  final String video;

  ProjectDetail({
    required this.id,
    required this.projectInfo,
    required this.location,
    required this.floorPlan,
    required this.gallery,
    required this.advert,
    required this.video,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'],
      projectInfo: ProjectInfo.fromJson(json['project_info']),
      location: ProjectLocation.fromJson(json['location']),
      floorPlan: (json['floor_plan'] as List?)?.map((item) => FloorPlan.fromJson(item)).toList() ?? [],
      gallery: (json['gallery'] as List?)?.map((item) => GalleryItem.fromJson(item)).toList() ?? [],
      advert: (json['advert'] as List?)?.map((item) => AdvertItem.fromJson(item)).toList() ?? [],
      video: json['video'],
    );
  }
}

class ProjectInfo {
  final String name;
  final String image;
  final String status;
  final String description;
  final String lastUpdate;
  final Progress progress;
  final List<String> images;

  ProjectInfo({
    required this.name,
    required this.image,
    required this.status,
    required this.description,
    required this.lastUpdate,
    required this.progress,
    required this.images,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      name: json['name'],
      image: json['image'],
      status: json['status'],
      description: json['description'],
      lastUpdate: json['last_update'],
      progress: Progress.fromJson(json['progress']),
      images: (json['images'] as List?)?.map((item) => item['image'] as String).toList() ?? [],
    );
  }
}

class Progress {
  final int percentage;
  final int structure;
  final int architecture;
  final int installation;
  final int foundation;

  Progress({
    required this.percentage,
    required this.structure,
    required this.architecture,
    required this.installation,
    required this.foundation,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      percentage: json['percentage'],
      structure: json['structure'],
      architecture: json['architecture'],
      installation: json['installation'],
      foundation: json['foundation'],
    );
  }
}

class ProjectLocation {
  final double lat;
  final double lng;

  ProjectLocation({required this.lat, required this.lng});

  factory ProjectLocation.fromJson(Map<String, dynamic> json) {
    return ProjectLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class FloorPlan {
  final int unitId;
  final String unitName;
  final String image;

  FloorPlan({
    required this.unitId,
    required this.unitName,
    required this.image,
  });

  factory FloorPlan.fromJson(Map<String, dynamic> json) {
    return FloorPlan(
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      image: json['image'],
    );
  }
}

class GalleryItem {
  final String thumbnailImage;
  final String mediumImage;

  GalleryItem({
    required this.thumbnailImage,
    required this.mediumImage,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      thumbnailImage: json['thumbnail_image'],
      mediumImage: json['medium_image'],
    );
  }
}

class AdvertItem {
  final String image;
  final String title;

  AdvertItem({
    required this.image,
    required this.title,
  });

  factory AdvertItem.fromJson(Map<String, dynamic> json) {
    return AdvertItem(
      image: json['image'],
      title: json['title'],
    );
  }
}
