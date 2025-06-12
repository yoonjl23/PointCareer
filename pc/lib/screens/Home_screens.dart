import 'package:flutter/material.dart';
import 'package:pc/screens/Activity_list_screens.dart';
import 'dart:math';

import 'package:pc/screens/Recommendation_input_screens.dart';
import 'package:pc/screens/job_list_screens.dart';

class HomeScreens extends StatelessWidget {
  final String userId;

  const HomeScreens({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 57,),
              Text('$userId님 안녕하세요!', style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xFF262626),
                letterSpacing: 24 * -0.03
              ),),
              const SizedBox(height: 8,),
              const Text('어떠한 활동을 하고 싶으신가요?', style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFF262626),
                letterSpacing: 18 * -0.03
              ),),
              const SizedBox(height: 40,),
          
              buildCard(
                title: '나만의 진로 맞춤 포인트 플랜',
                subtitle: '진로 연계 또는 효율 중심으로 쏙 뽑아드릴게요',
                imagePath: 'assets/images/targets.png',
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecommendationInputScreens(userId: userId,))
                  );
                }
              ),
              buildCard(
                title: '포인트 활동 전체 보기',
                subtitle: '다양한 포인트 활동을 둘러보세요',
                imagePath: 'assets/images/points.png',
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityListScreens(userId: userId,)));
                },
              ),
              buildCard(
                title: '경기대 전용 추천 채용 정보',
                subtitle: '다른 곳엔 없는 우리학교 기회만 알려드릴게요',
                imagePath: 'assets/images/bags.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobListScreens(userId: userId)));
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
                Color(0xFF62B7FF).withOpacity(0.5),
                Color(0xFFFFFFFF).withOpacity(0.5),
                Color(0xFFFFDCB5).withOpacity(0.5),
              ]
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
                    Text(title, style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFF262626),
                      letterSpacing: 24 * -0.03,
                    ),),
                    Text(subtitle, style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Color(0xFF262626),
                      letterSpacing: 18 * -0.03
                    ),),
                    const SizedBox(height: 10,),
                    Transform.rotate(
                      angle: -15 * pi / 180,
                      child: Image.asset(imagePath, width: 138, height: 124, fit: BoxFit.contain,)
                      )
                  ],
                  
                ),
              ),
            ],
          ),
      ),
    );
  }


}