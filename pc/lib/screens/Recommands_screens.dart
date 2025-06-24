import 'package:flutter/material.dart';
import 'package:pc/screens/Package_screens.dart';
import 'package:pc/screens/Nav_Screens.dart';

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

class _RecommandsScreensState extends State<RecommandsScreens> {
  @override
  void initState() {
    super.initState();
    print('📌 입력 받은 point: ${widget.point}');
    print('📌 입력 받은 deadline: ${widget.deadline}');
    print('📌 입력 받은 관심 분야: ${widget.interests}');
    // TODO: 이곳에서 API 호출
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              '맞춤 경로가 준비되었어요!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 7),
            const Text('가장 효율적인 활동을 추천해드려요', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            buildPackageSection(
              title: '진로 / 취업에 도움되는 패키지',
              userId: widget.userId,
            ),
            const SizedBox(height: 30),
            buildPackageSection(
              title: '시간효율 높은 포인트 집중 패키지',
              userId: widget.userId,
            ),
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
              builder:
                  (_) => NavScreens(
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
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }

  Widget buildPackageSection({required String title, required String userId}) {
    final List<String> tags = ['세일즈', '디자인', '개발'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PackageScreens(title: title, userId: userId),
          ),
        );
      },
      child: Container(
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
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
            Wrap(
              spacing: 8,
              children:
                  tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEDB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEA7500),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
