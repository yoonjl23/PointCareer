import 'package:flutter/material.dart';
import 'package:pc/screens/Activity_detail_screens.dart';
import 'package:pc/screens/Nav_Screens.dart';

class ActivityListScreens extends StatefulWidget {
  final String userId;
  const ActivityListScreens({super.key, required this.userId});

  @override
  State<ActivityListScreens> createState() => _ActivityListScreensState();
}

class _ActivityListScreensState extends State<ActivityListScreens> {
  String selectedValue = 'Select';
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> programs = [
  {
    'title': '[브라운백 시리즈] 오며가며 교양 토크쇼',
    'imagePath': 'assets/images/targets.png',
    'point': '10P',
    'type': '온라인',
    'duration': '2시간',
    'field': '자기계발',
    'category': '강연',
    'date': '2025년 3월 30일',
    'location': '수원 컨벤션 센터'
  },
  {
    'title': '(지역사회문제 창의적해결방안 제안)',
    'imagePath': 'assets/images/cat.jpg',
    'point': '15P',
    'type': '오프라인',
    'duration': '3시간',
    'field': '사회참여',
    'category': '공모전',
    'date': '2025년 3월 30일',
    'location': '수원 컨벤션 센터'
  },
  {
    'title': '[재맞고] 진로설계 포트폴리오 경진대회 청중평가단 모집',
    'imagePath': 'assets/images/points.png',
    'point': '5P',
    'type': '온라인',
    'duration': '1시간',
    'field': '진로탐색',
    'category': '봉사',
    'date': '2025년 3월 30일',
    'location': '수원 컨벤션 센터'
  }
];


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
            Text('KGU 프로그램',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color(0xFF7B7B7B),
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('원하시는 활동을 찾아보세요',
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      fontSize: 24)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ex) 맞춤형 입력 설정',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                      value: selectedValue,
                      items: ['Select', '최신순', '인기순']
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedValue = val!;
                        });
                      }),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                  children: programs.map((program) {
                    return buildProgramCard(
                      title: program['title']!,
                      imagePath: program['imagePath']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ActivityDetailScreens(
                            userId: widget.userId,
                            title: program['title']!,
                            imagePath: program['imagePath']!,
                            point: program['point']!,
                            type: program['type']!,
                            duration: program['duration']!,
                            field: program['field']!,
                            category: program['category']!,
                            date: program['date'] ?? '날짜 추후 공지',
                            location: program['location'] ?? '장소 추후 공지',
                          )
                        )
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => NavScreens(userId: widget.userId)),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      NavScreens(userId: widget.userId, initialIndex: index)),
            );
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color(0xFF7B7B7B),
        unselectedItemColor: Color(0xFF7B7B7B),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '마이페이지')
        ],
      ),
    );
  }

  Widget buildProgramCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
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
            Row(
              children: [
                buildTag("온라인"),
                const SizedBox(width: 4),
                buildTag("2주이내"),
                const SizedBox(width: 4),
                buildTag("포인트", highlight: true),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF262626),
                letterSpacing: -0.36,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '관련 분야',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFEA7500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            highlight ? const Color(0xFFFFEEDB) : const Color(0xFFE6F0FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color:
              highlight ? const Color(0xFFB86F0D) : const Color(0xFF2A6FB0),
        ),
      ),
    );
  }
}
