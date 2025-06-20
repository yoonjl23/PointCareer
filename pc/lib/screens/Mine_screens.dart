import 'package:flutter/material.dart';
import 'package:pc/db/database_helper.dart';
import 'package:pc/screens/Activity_detail_screens.dart';

class MineScreens extends StatefulWidget {
  final String userId;

  const MineScreens({super.key, required this.userId});

  @override
  State<MineScreens> createState() => _MineScreensState();
}

class _MineScreensState extends State<MineScreens> {
  late List<bool> isStarredList;

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

  @override
  void initState() {
    super.initState();
    isStarredList = List.generate(programs.length, (_) => false);
  }

  Future<Map<String, dynamic>?> fetchUserInfo() {
    return DatabaseHelper.instance.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Color(0xFF7B7B7B),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          final userInfo = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                /// 프로필
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/cat.jpg'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userInfo?['name'] ?? widget.userId}님',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF262626),
                          ),
                        ),
                        Text(
                          '${userInfo?['department'] ?? '산디과'} ${userInfo?['grade'] ?? '3학년'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF262626),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('찜한 프로그램 / 공고'),
                const SizedBox(height: 40),
                _buildSectionTitle('저장된 KGU 프로그램'),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 30),

                /// 카드 반복 출력
                ...List.generate(programs.length, (index) {
                  final program = programs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildSavedCard(index: index, program: program),
                  );
                }),

                const SizedBox(height: 60),
                const SizedBox(height: 40),
                _buildSectionTitle('저장된 추천채용공고'),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 30),

                /// 카드 반복 출력
                ...List.generate(programs.length, (index) {
                  final program = programs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildSavedCard(index: index, program: program),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 섹션 제목 텍스트
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF262626),
      ),
    );
  }

  /// 검색창
  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'ex) 맞춤형 입력 설정',
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  /// 찜한 카드 위젯
  Widget _buildSavedCard({
    required int index,
    required Map<String, String> program,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ActivityDetailScreens(
                  userId: widget.userId,
                  title: program['title'] ?? '',
                  imagePath: program['imagePath'] ?? '',
                  point: program['point'] ?? '',
                  type: program['type'] ?? '',
                  duration: program['duration'] ?? '',
                  field: program['field'] ?? '',
                  category: program['category'] ?? '',
                  date: program['date'] ?? '',
                  location: program['location'] ?? '',
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 뱃지 + 삭제 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildBadge(
                      'D - 4',
                      bg: const Color(0xFFDCE9FA),
                      color: const Color(0xFF2A6FB0),
                    ),
                    const SizedBox(width: 8),
                    _buildBadge(
                      '포인트 ${program['point'] ?? ''}',
                      bg: const Color(0xFFFFEEDB),
                      color: const Color(0xFFEA7500),
                    ),
                  ],
                ),
                const Icon(Icons.close, color: Color(0xFF999999)),
              ],
            ),
            const SizedBox(height: 12),

            /// 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                program['imagePath'] ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            /// 제목 + 별
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    program['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isStarredList[index]
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color:
                        isStarredList[index]
                            ? const Color(0xFF1877DD)
                            : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isStarredList[index] = !isStarredList[index];
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// 해시태그 (하드코딩)
            Wrap(
              spacing: 6,
              children:
                  ['#관심산업', '#관심영역', '#관심분야']
                      .map(
                        (tag) => Text(
                          tag,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 뱃지 위젯
  Widget _buildBadge(String text, {required Color bg, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
