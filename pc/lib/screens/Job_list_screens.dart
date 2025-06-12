import 'package:flutter/material.dart';
import 'package:pc/screens/Activity_detail_screens.dart';
import 'package:pc/screens/Nav_Screens.dart';

class JobListScreens extends StatefulWidget {
  final String userId;
  const JobListScreens({super.key, required this.userId});

  @override
  State<JobListScreens> createState() => _JobListScreensState();
}

class _JobListScreensState extends State<JobListScreens> {
  String selectedValue = 'Select';
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> programs = [
  {
    'title': '[토스페이먼츠]',
    'imagePath': 'assets/images/targets.png',
    'point': '10P',
    'type': '온라인',
    'duration': '2시간',
    'field': '자기계발',
    'category': '강연',
    'date': '2025년 9월 30일',
    'location': '수원 컨벤션 센터',
    'theme': '경영·사무/전체',
    'deadline' : '2025년 8월 1일'
  },
  {
    'title': '[(유)씨비세라티지트코리아]',
    'imagePath': 'assets/images/cat.jpg',
    'point': '15P',
    'type': '오프라인',
    'duration': '3시간',
    'field': '사회참여',
    'category': '공모전',
    'date': '2025년 10월 30일',
    'location': '수원 컨벤션 센터',
    'theme' : '영업·고객상담/일반영업'
  },
  {
    'title': '[재맞고] 진로설계 포트폴리오 경진대회 청중평가단 모집',
    'imagePath': 'assets/images/points.png',
    'point': '5P',
    'type': '온라인',
    'duration': '1시간',
    'field': '진로탐색',
    'category': '봉사',
    'date': '2025년 11월 30일',
    'location': '수원 컨벤션 센터',
    'theme':'경영·사무/전체'
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
            Text('추천 채용 공고',
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
              const SizedBox(height: 35),
              Text('우리 학교 추천채용 공고',
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 24 * - 0.03,
                      color: Color(0xFF262626)
                    )),
              
              Text('사람0, 잡코리0에서는 볼 수 없는\n채용 공고들을 살펴보세요!', style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 18 * -0.03,
                color: Color(0xFF262626)
              ),),
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
                      field: program['field']!,
                      deadline: getDDay(program['deadline'] ?? '상시모집'),
                      theme: program['theme']!,
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
  required String field,
  required String deadline, // 마감일 추가
  required String theme
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
          // 이미지 + 데드라인 Stack
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

          // 제목
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
          Text('\n$theme', style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 14 * -0.03,
            color: Color(0xFF7B7B7B)
          ),),
          // 분야 (예: 자기계발, 진로탐색 등)
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

  String getDDay(String dateString) {
  try {
    // 날짜에서 숫자만 추출
    final regex = RegExp(r'(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일');
    final match = regex.firstMatch(dateString);

    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);

      final deadline = DateTime(year, month, day);
      final now = DateTime.now();
      final diff = deadline.difference(now).inDays;

      if (diff > 0) {
        return 'D-$diff';
      } else if (diff == 0) {
        return 'D-Day';
      } else {
        return '마감';
      }
    } else {
      return '상시모집'; // 형식이 없을 때
    }
  } catch (e) {
    return '날짜 오류';
  }
}


}