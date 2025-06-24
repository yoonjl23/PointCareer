import 'package:flutter/material.dart';

import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Recruit_Detail_Screens.dart';
import 'package:pc/screens/job_list_screens.dart';

class PackageScreens extends StatefulWidget {
  final String title;
  final String userId;

  const PackageScreens({super.key, required this.title, required this.userId});

  @override
  State<PackageScreens> createState() => _PackageScreensState();
}

class _PackageScreensState extends State<PackageScreens> {
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
      'location': '수원 컨벤션 센터',
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
      'location': '수원 컨벤션 센터',
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
      'location': '수원 컨벤션 센터',
    },
  ];

  final List<Map<String, String>> jobs = [
    {
      'title': '[토스페이먼츠]',
      'imagePath': 'assets/images/targets.png',
      'point': '10P',
      'type': '온라인',
      'duration': '2시간',
      'field': '자기계발',
      'category': '강연',
      'date': '2025년 3월 30일',
      'location': '수원 컨벤션 센터',
      'theme': '경영/사무',
      'deadline': '2025년 5월 21일',
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
      'location': '수원 컨벤션 센터',
      'theme': '공모전',
      'deadline': '2025년 5월 21일',
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
      'location': '수원 컨벤션 센터',
      'theme': '진로',
      'deadline': '2025년 5월 21일',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isJobPackage =
        widget.title.contains('진로') || widget.title.contains('취업');
    final dataList = isJobPackage ? jobs : programs;

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: -0.72,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children:
                    dataList.map((program) {
                      final imagePath = program['imagePath'] ?? '';
                      final title = program['title'] ?? '';
                      final field = program['field'] ?? '';
                      final deadline = getDDay(program['deadline'] ?? '');
                      final theme = program['theme'] ?? '';

                      return isJobPackage
                          ? buildProgramCards(
                            title: title,
                            imagePath: imagePath,
                            field: field,
                            deadline: deadline,
                            theme: theme,
                            onTap: () => navigateToDetail(program),
                          )
                          : buildProgramCard(
                            title: title,
                            imagePath: imagePath,
                            onTap: () => navigateToDetail(program),
                            tags: [program['type'] ?? '', '2주이내', '포인트'],
                          );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => NavScreens(
                    token: widget.userId,
                    userId: widget.userId,
                    initialIndex: index,
                  ),
            ),
          );
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF7B7B7B),
        unselectedItemColor: const Color(0xFF7B7B7B),
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

  void navigateToDetail(Map<String, String> program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RecruitDetailScreens(
              userId: widget.userId,
              token: widget.title,
              recruitId: 1,
            ),
      ),
    );
  }

  Widget buildProgramCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required List<String> tags,
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
              children:
                  tags
                      .map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: buildTag(tag, highlight: tag.contains('포인트')),
                        ),
                      )
                      .toList(),
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
          ],
        ),
      ),
    );
  }

  Widget buildProgramCards({
    required String title,
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
            const SizedBox(height: 8),
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

  String getDDay(String dateString) {
    try {
      final regex = RegExp(r'(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일');
      final match = regex.firstMatch(dateString);
      if (match != null) {
        final year = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final day = int.parse(match.group(3)!);
        final deadline = DateTime(year, month, day);
        final now = DateTime.now();
        final diff = deadline.difference(now).inDays;

        if (diff > 0) return 'D-$diff';
        if (diff == 0) return 'D-Day';
        return 'D+${-diff}';
      }
      return '상시모집';
    } catch (_) {
      return '날짜 오류';
    }
  }
}
