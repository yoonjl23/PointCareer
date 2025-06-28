// lib/models/activity.dart
class Activity {
  final int pointId;
  final int pointPrice;
  final String isPointOnline;
  final String pointDuration;
  final String pointImageUrl;
  final String pointTitle;
  final List<String> pointCategories;
  final String pointLinkUrl;

  Activity({
    required this.pointId,
    required this.pointPrice,
    required this.isPointOnline,
    required this.pointDuration,
    required this.pointImageUrl,
    required this.pointTitle,
    required this.pointCategories,
    required this.pointLinkUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      pointId: json['point_id'],
      pointPrice: json['point_price'],
      isPointOnline: json['is_point_online'] ?? '',
      pointDuration: json['point_duration']?.toString() ?? '',
      pointImageUrl: json['point_image_url'] ?? '',
      pointTitle: json['point_title'],
      pointCategories: List<String>.from(json['point_categories'] ?? []),
      pointLinkUrl: json['point_link_url'] ?? '', 
    );
  }
}
