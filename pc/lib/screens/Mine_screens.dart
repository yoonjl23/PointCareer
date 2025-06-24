import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ✅ 모델 클래스
class MyPageData {
  final Profile profile;
  final List<Point> points;
  final List<Recruit> recruits;

  MyPageData({required this.profile, required this.points, required this.recruits});

  factory MyPageData.fromJson(Map<String, dynamic> json) {
    return MyPageData(
      profile: Profile.fromJson(json['profile']),
      points: (json['points'] as List).map((e) => Point.fromJson(e)).toList(),
      recruits: (json['recruits'] as List).map((e) => Recruit.fromJson(e)).toList(),
    );
  }
}

class Profile {
  final String userName;
  final String userMajor;
  final int userGrade;
  final String userEmail;
  final String userLoginId;

  Profile({required this.userName, required this.userMajor, required this.userGrade, required this.userEmail, required this.userLoginId});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userName: json['userName'],
      userMajor: json['userMajor'],
      userGrade: json['userGrade'],
      userEmail: json['userEmail'],
      userLoginId: json['userLoginId'],
    );
  }
}

class Point {
  final int pointId;
  final String pointName;
  final String pointDeadline;
  final int pointPrice;
  final String pointImageUrl;

  Point({required this.pointId, required this.pointName, required this.pointDeadline, required this.pointPrice, required this.pointImageUrl});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      pointId: json['pointId'],
      pointName: json['pointName'],
      pointDeadline: json['pointDeadline'],
      pointPrice: json['pointPrice'],
      pointImageUrl: json['pointImageUrl'],
    );
  }
}

class Recruit {
  final int recruitId;
  final String recruitName;
  final String recruitCompany;
  final String recruitDeadline;
  final String recruitImageUrl;

  Recruit({required this.recruitId, required this.recruitName, required this.recruitCompany, required this.recruitDeadline, required this.recruitImageUrl});

  factory Recruit.fromJson(Map<String, dynamic> json) {
    return Recruit(
      recruitId: json['recruitId'],
      recruitName: json['recruitName'],
      recruitCompany: json['recruitCompany'],
      recruitDeadline: json['recruitDeadline'],
      recruitImageUrl: json['recruitImageUrl'],
    );
  }
}

// ✅ API 요청 함수
Future<MyPageData?> fetchMyPageData(String userId) async {
  final url = Uri.parse('http://43.201.74.44/api/v1/users/profile?userId=$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return MyPageData.fromJson(jsonData['result']);
  } else {
    print('서버 응답 오류: ${response.statusCode}');
    return null;
  }
}

// ✅ 마이페이지 UI
class MyPageScreen extends StatelessWidget {
  final String userId;

  const MyPageScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: FutureBuilder<MyPageData?>(
        future: fetchMyPageData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('데이터를 불러올 수 없습니다.'));
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('👤 ${data.profile.userName} (${data.profile.userMajor} ${data.profile.userGrade}학년)'),
              const SizedBox(height: 20),
              const Text('⭐ 포인트 프로그램:'),
              ...data.points.map((p) => ListTile(
                    title: Text(p.pointName),
                    subtitle: Text('마감: ${p.pointDeadline} | ${p.pointPrice}P'),
                  )),
              const Divider(),
              const Text('💼 추천 채용 공고:'),
              ...data.recruits.map((r) => ListTile(
                    title: Text(r.recruitName),
                    subtitle: Text('${r.recruitCompany} | 마감: ${r.recruitDeadline}'),
                  )),
            ],
          );
        },
      ),
    );
  }
}