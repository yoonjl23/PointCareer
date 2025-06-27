import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Activity_list_screens.dart';
import 'package:pc/screens/Recommendation_input_screens.dart';
import 'package:pc/screens/job_list_screens.dart';

class HomeScreens extends StatefulWidget {
  final String token;
  final String userId;

  const HomeScreens({super.key, required this.token, required this.userId});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  String userName = '';
  String loginId = '';
  int? usedId;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final userInfo = await fetchUserInfo(widget.token);
    print('🧪 사용자 정보: $userInfo');

    if (userInfo != null) {
      setState(() {
        loginId = userInfo['login_id'] ?? '';
        userName = userInfo['user_name'] ?? ''; // 여기서 null이거나 ''일 수 있음
        usedId = userInfo['user_id'];
      });
    }
  }

  Future<Map<String, dynamic>?> fetchUserInfo(String token) async {
    final url = Uri.parse('http://43.201.74.44/api/v1/users/me');

    final response = await http.get(
      url,
      headers: {'Authorization': '$token', 'Accept': 'application/json'},
    );

    print('📥 사용자 조회 응답 코드: ${response.statusCode}');
    print('📥 사용자 조회 응답 본문: ${response.body}');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      return data['result']; // ✅ 여기엔 login_id, user_name만 있음
    } else {
      print('❌ 사용자 정보 응답 실패 또는 본문 없음');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 57),
              Text(
                userName.isEmpty ? '사용자님 안녕하세요!' : '$userName님 안녕하세요!',
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF262626),
                  letterSpacing: -0.72,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '어떠한 활동을 하고 싶으신가요?',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF262626),
                  letterSpacing: -0.54,
                ),
              ),
              const SizedBox(height: 40),
              buildCard(
                title: '나만의 진로 맞춤 포인트 플랜',
                subtitle: '진로 연계 또는 효율 중심으로 쏙 뽑아드릴게요',
                imagePath: 'assets/images/targets.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RecommendationInputScreens(
                            userId: usedId.toString() ?? '',
                            token: widget.token,
                            userName: userName,
                          ),
                    ),
                  );
                },
              ),
              buildCard(
                title: '포인트 활동 전체 보기',
                subtitle: '다양한 포인트 활동을 둘러보세요',
                imagePath: 'assets/images/points.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ActivityListScreens(
                            userId: widget.userId,
                            token: widget.token,
                          ),
                    ),
                  );
                },
              ),
              buildCard(
                title: '경기대 전용 추천 채용 정보',
                subtitle: '다른 곳엔 없는 우리학교 기회만 알려드릴게요',
                imagePath: 'assets/images/bags.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => JobListScreens(
                            userId: widget.userId,
                            token: widget.token,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String subtitle,
    required String imagePath,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.5,
            colors: [
              const Color(0xFF62B7FF).withOpacity(0.5),
              const Color(0xFFFFFFFF).withOpacity(0.5),
              const Color(0xFFFFDCB5).withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFF262626),
                      letterSpacing: -0.72,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Color(0xFF262626),
                      letterSpacing: -0.54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Transform.rotate(
                    angle: -15 * pi / 180,
                    child: Image.asset(
                      imagePath,
                      width: 138,
                      height: 124,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
