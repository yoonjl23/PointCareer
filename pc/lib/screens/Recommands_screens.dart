import 'package:flutter/material.dart';
import 'package:pc/screens/Nav_Screens.dart';

class RecommandsScreens extends StatefulWidget {
  final String userId;

  const RecommandsScreens({super.key, required this.userId});

  @override
  State<RecommandsScreens> createState() => _RecommandsScreensState();
}

class _RecommandsScreensState extends State<RecommandsScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('맞춤형 추천', style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xFF7B7B7B),
            )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              '맞춤 경로가 준비되었어요!',
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              '가장 효율적인 활동을 추천해드려요',
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 30),

            // 패키지 카드 1
            buildPackageSection(title: '진로 / 취업에 도움되는 패키지'),

            const SizedBox(height: 30),

            // 패키지 카드 2
            buildPackageSection(title: '시간효율높은 포인트 집중 패키지'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => NavScreens(userId: widget.userId)),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => NavScreens(userId: widget.userId, initialIndex: index,)),
            );
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color(0xFF7B7B7B),
        unselectedItemColor: Color(0xFF7B7B7B),
        items: [BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
        label: '홈',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline),
        label: '마이페이지')
        ],  
      ),
    );
  }

  Widget buildPackageSection({required String title}) {
    final List<String> tags = ['세일즈', '디자인', '개발'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 16),

          // 가로 스크롤 이미지 리스트
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('이미지')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 태그
          Wrap(
            spacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEDB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFEA7500),
                    fontFamily: "Roboto",
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
