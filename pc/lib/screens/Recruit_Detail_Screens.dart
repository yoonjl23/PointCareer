// 변환된 RecruitDetailScreens → ActivityDetailScreens 스타일 코드
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Nav_Screens.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruitDetailScreens extends StatefulWidget {
  final String userId;
  final String token;
  final int recruitId;

  const RecruitDetailScreens({
    super.key,
    required this.userId,
    required this.token,
    required this.recruitId,
  });

  @override
  State<RecruitDetailScreens> createState() => _RecruitDetailScreensState();
}

class _RecruitDetailScreensState extends State<RecruitDetailScreens> {
  Map<String, dynamic>? recruitData;
  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecruitDetail();
  }

  Future<void> fetchRecruitDetail() async {
    final url = Uri.parse(
      'http://43.201.74.44/api/v1/recruits/${widget.recruitId}',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': widget.token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      setState(() {
        recruitData = decoded['result']['recruit'];
        isLoading = false;
      });
    } else {
      print('❌ 채용 정보 불러오기 실패: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (recruitData == null) {
      return const Scaffold(body: Center(child: Text('데이터를 불러오지 못했습니다.')));
    }

    final title = recruitData?['recruitName'] ?? '';
    final deadline = recruitData?['recruitDeadline']?.split('T')[0] ?? '';
    final company = recruitData?['recruitCompany'] ?? '-';
    final detail = recruitData?['recruitDetail'] ?? '-';
    final location = recruitData?['recruitPlace'] ?? '-';
    final imageUrl = recruitData?['recruitImageUrl'] ?? '';
    final safeImageUrl =
        (imageUrl is String && imageUrl.isNotEmpty) ? imageUrl : '';
    final link = recruitData?['recruitLinkUrl'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '채용 상세정보',
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Color(0xFF7B7B7B),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 28,
                  color: const Color(0xFF1877DD),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto",
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.business),
                SizedBox(width: 6),
                Text(company),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 6),
                Text(deadline),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 6),
                Text(location),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '상세 설명',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(detail, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  safeImageUrl.isNotEmpty
                      ? Image.network(
                        safeImageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/cat.jpg', // ✅ 대체 이미지 경로
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset(
                        'assets/images/cat.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6E7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (link.isNotEmpty) {
                    final uri = Uri.parse(link);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('링크를 열 수 없습니다.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('링크 정보가 없습니다.')),
                    );
                  }
                },
                child: const Text(
                  '채용 정보 보러가기',
                  style: TextStyle(
                    color: Color(0xFF1877DD),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) {
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
          }
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
}
