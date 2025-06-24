import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Recruit_Detail_Screens.dart';

class JobListScreens extends StatefulWidget {
  final String userId;
  final String token;

  const JobListScreens({super.key, required this.userId, required this.token});

  @override
  State<JobListScreens> createState() => _JobListScreensState();
}

class _JobListScreensState extends State<JobListScreens> {
  List<Map<String, dynamic>> recruitList = [];
  bool isLoading = true;
  String selectedValue = 'Select';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecruits();
  }

  Future<void> searchActivities(String keyword) async {
    final url = Uri.parse(
      'http://43.201.74.44/api/v1/recruits/search?keyword=$keyword',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': '${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        recruitList = data['result']['points'];
      });
    } else {
      print('❌ 검색 실패: ${response.statusCode}');
      print('응답: ${response.body}');
    }
  }

  Future<void> fetchRecruits() async {
    setState(() => isLoading = true);

    final url = Uri.parse('http://43.201.74.44/api/v1/recruits');
    final response = await http.get(
      url,
      headers: {
        'Authorization': '${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> recruits = data['result']['recruits'];
      setState(() {
        recruitList = recruits.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      setState(() {
        recruitList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        title: const Center(
          child: Text(
            '추천 채용 공고',
            style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xFF7B7B7B),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const Text(
                '우리 학교 추천채용 공고',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  letterSpacing: -0.72,
                  color: Color(0xFF262626),
                ),
              ),
              const Text(
                '사람0, 잡코리0에서는 볼 수 없는\n채용 공고들을 살펴보세요!',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  letterSpacing: -0.54,
                  color: Color(0xFF262626),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ex) 기업명, 분야 등 검색',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final keyword = searchController.text.trim();
                        if (keyword.isNotEmpty) {
                          searchActivities(keyword);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: selectedValue,
                    items:
                        ['Select', '최신순', '인기순']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : recruitList.isEmpty
                        ? const Center(child: Text('채용 공고가 없습니다.'))
                        : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                          children:
                              recruitList.map((recruit) {
                                final deadline = getDDay(
                                  recruit['recruitDeadline'] ?? '',
                                );
                                return buildProgramCard(
                                  title: recruit['recruitName'] ?? '제목 없음',
                                  company: recruit['recruitCompany'] ?? '-',
                                  imagePath:
                                      recruit['recruitImageUrl'] ??
                                      'assets/images/default.png',
                                  field:
                                      (recruit['favoriteCategories'] as List?)
                                          ?.join(', ') ??
                                      '',
                                  deadline: deadline,
                                  theme:
                                      (recruit['recruitJobCategories'] as List?)
                                          ?.join(', ') ??
                                      '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => RecruitDetailScreens(
                                              userId: widget.userId,
                                              token: widget.token,
                                              recruitId: recruit['recruitId'],
                                            ),
                                      ),
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
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => NavScreens(
                    userId: widget.userId,
                    token: widget.token,
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

  Widget buildProgramCard({
    required String title,
    required String company,
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
                  child: Image.network(
                    imagePath,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Image.asset(
                          'assets/images/cat.jpg',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
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
            Text(company),
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
            const SizedBox(height: 6),
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

  String getDDay(String isoDate) {
    try {
      final deadline = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = deadline.difference(now).inDays;
      if (diff > 0) return 'D-$diff';
      if (diff == 0) return 'D-Day';
      return '마감';
    } catch (_) {
      return '상시모집';
    }
  }
}
