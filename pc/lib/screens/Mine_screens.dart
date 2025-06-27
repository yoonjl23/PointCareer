import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Activity_Detail_screens.dart';
import 'package:pc/screens/Recruit_Detail_Screens.dart';

// ✅ 데이터 모델 정의
class MyPageData {
  final Profile profile;
  final List<Point> points;
  final List<Recruit> recruits;

  MyPageData({
    required this.profile,
    required this.points,
    required this.recruits,
  });

  factory MyPageData.fromJson(Map<String, dynamic> json) {
  return MyPageData(
    profile: Profile.fromJson(json['profile']),
    points: (json['points'] as List).map((e) => Point.fromJson(e)).toList(),
    recruits: (json['recruits'] as List).map((e) => Recruit.fromJson(e)).toList(),
  );
}

}

class Profile {
  final String userName, userMajor, userEmail, userLoginId;
  final int userGrade;

  Profile({
    required this.userName,
    required this.userMajor,
    required this.userGrade,
    required this.userEmail,
    required this.userLoginId,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    userName: json['userName'],
    userMajor: json['userMajor'],
    userGrade: json['userGrade'],
    userEmail: json['userEmail'],
    userLoginId: json['userLoginId'],
  );
}

class Point {
  final int pointId, pointPrice, bookmarkId;
  final String pointName, pointDeadline, pointImageUrl, bookmarkType;

  Point({
    required this.pointId,
    required this.pointName,
    required this.pointDeadline,
    required this.pointPrice,
    required this.pointImageUrl,
    required this.bookmarkId,
    required this.bookmarkType,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    pointId: json['pointId'] ?? 0,
    pointName: json['pointName'] ?? '',
    pointDeadline: json['pointDeadline'] ?? '',
    pointPrice: json['pointPrice'] ?? 0,
    pointImageUrl: json['pointImageUrl'] ?? '',
    bookmarkId: json['bookmark_id'] ?? 0,
    bookmarkType: json['bookmark_type'] ?? '',
  );
}

class Recruit {
  final int recruitId;
  final String recruitName, recruitCompany, recruitDeadline, recruitImageUrl;
  final List<String> favoriteCategories;
  final List<String> recruitJobCategories;

  Recruit({
    required this.recruitId,
    required this.recruitName,
    required this.recruitCompany,
    required this.recruitDeadline,
    required this.recruitImageUrl,
    required this.favoriteCategories,
    required this.recruitJobCategories,
  });

  factory Recruit.fromJson(Map<String, dynamic> json) => Recruit(
    recruitId: json['recruitId'],
    recruitName: json['recruitName'],
    recruitCompany: json['recruitCompany'],
    recruitDeadline: json['recruitDeadline'],
    recruitImageUrl: json['recruitImageUrl'],
    favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
    recruitJobCategories: List<String>.from(json['recruitJobCategories'] ?? []),
  );
}

// ✅ 올바른 위치: 전역 fetch 함수
Future<MyPageData?> fetchMyPageData(String userId, String token) async {
  print('🚀 fetchMyPageData 시작');

  final url = Uri.parse(
    'http://43.201.74.44/api/v1/users/profile?userId=$userId',
  );

  final response = await http.get(url, headers: {'Authorization': token});

  print('📡 응답 statusCode: ${response.statusCode}');
  print('📦 응답 body: ${response.body}');

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    return MyPageData.fromJson(decoded['result']);
  } else {
    print('❌ 서버 응답 오류: ${response.statusCode}');
    return null;
  }
}

// ✅ 메인 위젯
class MyPageScreen extends StatefulWidget {
  final String userId, token;
  const MyPageScreen({super.key, required this.userId, required this.token});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late Future<MyPageData?> futureData;

  @override
  void initState() {
    super.initState();
    print('📍 MyPageScreen initState 실행됨'); 
    futureData = fetchMyPageData(widget.userId, widget.token);
  }

  // ✅ 북마크 삭제
  Future<void> deleteBookmark(int bookmarkId, String bookmarkType) async {
     print('🚀 fetchMyPageData 시작');
    final url = Uri.parse(
      'http://43.201.74.44/api/v1/bookmarks/$bookmarkType/$bookmarkId',
    );

    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': widget.token},
      );

      print('🧨 [DELETE] 응답 코드: ${response.statusCode}');
      print('🧨 [DELETE] 응답 바디: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (json['code'] == 0 || json['code'] == 20004)) {
        print('✅ 북마크 삭제 성공');
        setState(() {
          futureData = fetchMyPageData(widget.userId, widget.token);
        });
      } else {
        print('❌ 북마크 삭제 실패: ${json['message']}');
      }
    } catch (e) {
      print('❗ 예외 발생: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        centerTitle: true,
        title: const Text('마이페이지', style: TextStyle(color: Color(0xFF7B7B7B))),
      ),
      body: FutureBuilder<MyPageData?>(
        future: futureData,
        builder: (context, snapshot) {
          print('📊 snapshot.connectionState: ${snapshot.connectionState}');
    print('📊 snapshot.hasData: ${snapshot.hasData}');
    print('📊 snapshot.hasError: ${snapshot.hasError}');
    print('📊 snapshot.data: ${snapshot.data}');
    print('📊 snapshot.error: ${snapshot.error}');
    if (snapshot.hasError) {
  return Center(child: Text('에러 발생: ${snapshot.error}'));
}

          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/cat.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.profile.userName),
                      Text(
                        '${data.profile.userMajor} ${data.profile.userGrade}학년',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '찜한 프로그램 / 공고',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                '저장된 KGU 프로그램',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              ...data.points.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildProgramCard(
                      title: p.pointName,
                      imagePath: p.pointImageUrl,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActivityDetailScreens(
                              userId: widget.userId,
                              token: widget.token,
                              pointId: p.pointId,
                            ),
                          ),
                        );
                      },
                    
                      point: '${p.pointPrice}P',
                    ),
                  ),
                ).toList(),

              const SizedBox(height: 20),
              const Text('저장된 추천채용공고', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),
              ...data.recruits.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: buildRecruitCard(
                    title: r.recruitName,
                    company: r.recruitCompany,
                    imagePath: r.recruitImageUrl,
                    deadline: getDDay(r.recruitDeadline),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecruitDetailScreens(
                            userId: widget.userId,
                            token: widget.token,
                            recruitId: r.recruitId,
                          ),
                        ),
                      );
                    },
                  
                    field: r.favoriteCategories.join(', '),
                    theme: r.recruitJobCategories.join(', '),
                    ),
                ),
                ).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget buildProgramCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
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
  Widget buildRecruitCard({
    required String title,
    required String company,
    required String imagePath,
    required VoidCallback onTap,
    required String field,
    required String deadline,
    required String theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Image.network(
                      imagePath,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Image.asset(
                            'assets/images/cat.jpg',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      deadline,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2A6FB0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(company),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF262626),
                letterSpacing: -0.03,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              theme,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: -0.42,
                color: Color(0xFF7B7B7B),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                field,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFEA7500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDDay(String isoDate) {
  try {
    final deadline = DateTime.parse(isoDate);
    final now = DateTime.now();

    // 날짜만 추출하여 D-day 계산
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    final nowDate = DateTime(now.year, now.month, now.day);

    final diff = deadlineDate.difference(nowDate).inDays;

    if (diff > 0) return 'D-$diff';
    if (diff == 0) return 'D-Day';
    return '마감';
  } catch (_) {
    return '상시모집';
  }
}

}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.text,
    this.color = const Color(0xFFEAF1FF),
    this.textColor = const Color(0xFF1877DD),
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: TextStyle(fontSize: 12, color: textColor)),
  );

}
