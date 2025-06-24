import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      recruits:
          (json['recruits'] as List).map((e) => Recruit.fromJson(e)).toList(),
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
    pointId: json['pointId'],
    pointName: json['pointName'],
    pointDeadline: json['pointDeadline'],
    pointPrice: json['pointPrice'],
    pointImageUrl: json['pointImageUrl'],
    bookmarkId: json['bookmark_id'],
    bookmarkType: json['bookmark_type'],
  );
}

class Recruit {
  final int recruitId;
  final String recruitName, recruitCompany, recruitDeadline, recruitImageUrl;

  Recruit({
    required this.recruitId,
    required this.recruitName,
    required this.recruitCompany,
    required this.recruitDeadline,
    required this.recruitImageUrl,
  });

  factory Recruit.fromJson(Map<String, dynamic> json) => Recruit(
    recruitId: json['recruitId'],
    recruitName: json['recruitName'],
    recruitCompany: json['recruitCompany'],
    recruitDeadline: json['recruitDeadline'],
    recruitImageUrl: json['recruitImageUrl'],
  );
}

// ✅ 데이터 요청
Future<MyPageData?> fetchMyPageData(String userId, String token) async {
  final url = Uri.parse(
    'http://43.201.74.44/api/v1/users/profile?userId=$userId',
  );
  final response = await http.get(url, headers: {'Authorization': token});
  if (response.statusCode == 200) {
    return MyPageData.fromJson(jsonDecode(response.body)['result']);
  } else {
    print('서버 응답 오류: ${response.statusCode}');
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
    futureData = fetchMyPageData(widget.userId, widget.token);
  }

  // ✅ 북마크 삭제
  Future<void> deleteBookmark(int bookmarkId, String bookmarkType) async {
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
              ...data.points.map((p) => buildPointCard(p)),
              const SizedBox(height: 20),
              const Text('저장된 추천채용공고', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),
              ...data.recruits.map(
                (r) => ListTile(
                  title: Text(r.recruitName),
                  subtitle: Text(
                    '${r.recruitCompany} | 마감: ${r.recruitDeadline}',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPointCard(Point point) {
    final dDay = calculateDDay(point.pointDeadline);

    // 🧷 bookmarkId 디버깅
    print('🧷 bookmarkId: ${point.bookmarkId}, type: ${point.bookmarkType}');

    return GestureDetector(
      onTap: () {
        // 👉 여기에 원하는 동작 추가 (예: 상세페이지 이동)
        print('🖱️ ${point.pointName} 카드 탭됨');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Badge(text: 'D-$dDay'),
                const SizedBox(width: 8),
                _Badge(
                  text: '포인트 ${point.pointPrice}점',
                  color: Color(0xFFF3ECE4),
                  textColor: Color(0xFF935D2D),
                ),
                const Spacer(),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed:
                          () => deleteBookmark(
                            point.bookmarkId,
                            point.bookmarkType,
                          ),
                    ),
                    const Icon(Icons.star, color: Color(0xFF1877DD), size: 28),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              point.pointName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  int calculateDDay(String deadline) {
    final today = DateTime.now();
    final end = DateTime.tryParse(deadline) ?? today;
    return end.difference(today).inDays;
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
