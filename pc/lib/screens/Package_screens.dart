import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Activity_Detail_screens.dart';
import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Recruit_Detail_Screens.dart';
import 'package:pc/models/activity.dart';

class PackageScreens extends StatefulWidget {
  final String userId;
  final String token;
  final List<Activity> activities;

  const PackageScreens({
    super.key,
    required this.token,
    required this.userId,
    required this.activities
  });

  @override
  State<PackageScreens> createState() => _PackageScreensState();
}

class _PackageScreensState extends State<PackageScreens> {
  String selectedValue = 'Select';
  final TextEditingController searchController = TextEditingController();
  List<Activity> points = [];

  @override
  void initState() {
    super.initState();
    if (widget.activities != null) {
      points = widget.activities!;
    }
    fetchSortedRecruits('최신순');
  }

  Future<void> fetchSortedRecruits(String sortType) async {
    final url = Uri.parse(
      'http://43.201.74.44/api/v1/points/activities/sort?sortType=$sortType',
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

  final result = data['result'];
  if (result != null && result['points'] != null) {
  setState(() {
    points = (result['points'] as List)
        .map((e) => Activity.fromJson(e))
        .toList();
  });
} else {
    print('⚠️ result 또는 points가 null입니다');
    setState(() {
      points = [];
    });
  }
} else {
  print('📡 요청 실패: ${response.statusCode}');
  print('응답 내용: ${response.body}');
}

  }

  Future<void> searchActivities(String keyword) async {
    final url = Uri.parse(
      'http://43.201.74.44/api/v1/points/activities/search?keyword=$keyword',
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
        points = data['result']['points'];
      });
    } else {
      print('❌ 검색 실패: ${response.statusCode}');
      print('응답: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        title: const Text(
          'KGU 프로그램',
          style: TextStyle(color: Color(0xFF7B7B7B)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                '원하시는 활동을 찾아보세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                  children:
                      points.map((activity) {
                        return buildProgramCard(
                          title: activity.pointTitle ?? '제목 없음',
                          imagePath: activity.pointImageUrl ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ActivityDetailScreens(
                                      userId: widget.userId,
                                      token: widget.token,
                                      pointId: activity.pointId,
                                    ),
                              ),
                            );
                          },
                          onoff: activity.isPointOnline ?? '정보 없음',
                          duration: '${activity.pointDuration}' ?? '정보 없음',
                          point: '${activity.pointPrice}P',
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

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'ex) 맞춤형 입력 설정',
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
    );
  }

  Widget _buildDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: selectedValue,
          items:
              [
                'Select',
                '최신순',
                '인기순',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {
            setState(() {
              selectedValue = val!;
            });
            if (val != 'Select') {
              fetchSortedRecruits(val!); // ⬅ 정렬 API 호출
            }
          },
        ),
      ],
    );
  }

  Widget buildProgramCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required String onoff,
    required String duration,
    required String point,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              clipBehavior: Clip.hardEdge,
              children: [
                buildTag(onoff),
                buildTag(duration),
                buildTag(point, highlight: true),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  imagePath.isNotEmpty
                      ? Image.network(
                        imagePath,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            color: Colors.grey[300],
                          ); // 에러 시 기본
                        },
                      )
                      : Container(height: 100, color: Colors.grey[300]),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF262626),
                letterSpacing: 12 * -0.03,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '관련 분야',
                style: TextStyle(fontSize: 12, color: Color(0xFFEA7500)),
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
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 10 * -0.03,
          fontWeight: FontWeight.w400,
          color: highlight ? const Color(0xFFB86F0D) : const Color(0xFF2A6FB0),
        ),
      ),
    );
  }
}
