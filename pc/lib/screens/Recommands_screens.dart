import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Activity_detail_screens.dart';
import 'package:pc/screens/Activity_list_screens.dart';
import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Package_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pc/models/activity.dart';


class RecommandsScreens extends StatefulWidget {
  final String userId;
  final String token;
  final int point;
  final String deadline;
  final List<String> interests;

  const RecommandsScreens({
    super.key,
    required this.userId,
    required this.token,
    required this.point,
    required this.deadline,
    required this.interests,
  });

  @override
  State<RecommandsScreens> createState() => _RecommandsScreensState();
}

Map<String, String> interestLabelToEnum = {
  'IT/소프트웨어 제조업': 'IT_DEVELOP',
  '공공/정부기관': 'VOLUNTEER_PUBLIC',
  '교육': 'SPECIALIZED_MAJOR',
  '미디어/엔터테인먼트': 'CULTURE_ART',
  '유통/소매': 'SALES_CUSTOMER',
  '농업/식품': 'ETC',
  '기타 서비스업': 'ETC',
  '의료/헬스케어': 'HR_ORGANIZATION',
  '에너지/화학': 'RND',
  '건설/부동산': 'OPERATION_MANAGEMENT',
  '운송/물류': 'OPERATION_MANAGEMENT',
};


class RecommendationGroup {
  final String groupName;
  final int targetPoints;
  final int recommendedPoints;
  final int lackingPoints;
  final bool isSatisfied;
  final List<Activity> activities;

  RecommendationGroup({
    required this.groupName,
    required this.targetPoints,
    required this.recommendedPoints,
    required this.lackingPoints,
    required this.isSatisfied,
    required this.activities,
  });

  factory RecommendationGroup.fromJson(Map<String, dynamic> json) {
  return RecommendationGroup(
    groupName: json['group_name'] ?? '',
    targetPoints: json['target_points'] ?? 0,
    recommendedPoints: json['recommended_points'] ?? 0,
    lackingPoints: json['lacking_points'] ?? 0,
    isSatisfied: (json['is_target_point_satisfied'] ??
                  json['_target_point_satisfied']) == true,
    activities: (json['activities'] as List? ?? [])
        .map((e) => Activity.fromJson(e))
        .toList(),
  );
}
}

class _RecommandsScreensState extends State<RecommandsScreens> {
  List<RecommendationGroup> recommendationGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
  // ✅ 한글 관심사 → API enum 값으로 매핑
  final convertedInterests = widget.interests
      .map((label) => interestLabelToEnum[label])
      .where((value) => value != null)
      .cast<String>()
      .toList();

  final favoriteQuery = convertedInterests
      .map((e) => 'favorite=${Uri.encodeQueryComponent(e)}')
      .join('&');

  // ✅ 날짜만 주어졌다면 시간 붙이기
  String deadlineParam = widget.deadline;
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(widget.deadline)) {
    deadlineParam = '${widget.deadline}T23:59:59';
  }

  final url =
      'http://43.201.74.44/api/v1/points/recommends?point=${widget.point}&deadline=${Uri.encodeQueryComponent(deadlineParam)}&$favoriteQuery';

  final uri = Uri.parse(url);
  final headers = {'Authorization': widget.token};

  print('🌐 요청 URL: $url');
  print('🔐 Authorization 헤더: ${widget.token}');

  try {
    final response = await http.get(uri, headers: headers);
    print('📦 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final groups = decoded['result']['recommendation_groups'] as List;

      setState(() {
        recommendationGroups =
            groups.map((e) => RecommendationGroup.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('API 실패: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ 추천 API 에러: $e');
    setState(() => isLoading = false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Center(
          child: Text(
            '맞춤형 추천',
            style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xFF7B7B7B),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recommendationGroups.isEmpty
              ? const Center(child: Text('추천 결과가 없습니다.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '맞춤 경로가 준비되었어요!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 7),
                      const Text('가장 효율적인 활동을 추천해드려요',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 30),
                      ...recommendationGroups.map(buildGroupCard).toList(),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: 1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF7B7B7B),
        unselectedItemColor: const Color(0xFF7B7B7B),
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NavScreens(
                token: widget.token,
                userId: widget.userId,
                initialIndex: index,
              ),
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
      ),
    );
  }

  Widget buildGroupCard(RecommendationGroup group) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PackageScreens(token: widget.token, userId: widget.userId, activities: group.activities,)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.groupName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...group.activities.map(buildActivityTile).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildActivityTile(Activity activity) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: activity.pointImageUrl.isNotEmpty
          ? Image.network(
              activity.pointImageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/cat.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                );
              },
            )
          : const Icon(Icons.image_not_supported),
      title: Text(activity.pointTitle),
      subtitle: Text(
        '${activity.pointPrice}포인트 · ${activity.pointDuration} · ${activity.isPointOnline}',
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ActivityDetailScreens(userId: widget.userId, token: widget.token, pointId: activity.pointId)));
      } ,
    );
  }

  Widget buildProgramCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required String onoff,
    required String duration,
    required String point,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildTag(onoff),
                const SizedBox(width: 4),
                buildTag(duration),
                const SizedBox(width: 4),
                buildTag(point, highlight: true),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  imagePath.isNotEmpty
                      ? Image.network(
                        imagePath,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            color: Colors.grey[300],
                          ); // 에러 시 기본
                        },
                      )
                      : Container(height: 100, color: Colors.grey[300]),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF262626),
                letterSpacing: 12 * -0.03,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '관련 분야',
                style: TextStyle(fontSize: 12, color: Color(0xFFEA7500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFEEDB) : const Color(0xFFE6F0FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: highlight ? const Color(0xFFB86F0D) : const Color(0xFF2A6FB0),
        ),
      ),
    );
  }
}
