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
  int? bookmarkId;
  String? bookmarkType;

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
        'Authorization': '${widget.token.trim()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final bookmark = decoded['result']['bookmark'];
      setState(() {
        if (bookmark != null &&
            bookmark is Map &&
            bookmark['bookmark_id'] != null) {
              bookmarkId = bookmark['bookmark_id'];
              isFavorite = true;
            } else {
              bookmarkId = null;
              isFavorite = false;
            }
        recruitData = decoded['result']['recruit'];
        isLoading = false;
      });
    } else {
      print('❌ 채용 정보 불러오기 실패: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleBookmark() async {
  final url = Uri.parse('http://43.201.74.44/api/v1/bookmarks');
  final body = jsonEncode({'id': widget.recruitId, 'target_type': 'RECRUIT'});

  try {
    print('📤 북마크 생성 요청 바디: $body');
    final response = await http.post(
      url,
      headers: {
        'Authorization': '${widget.token.trim()}',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print('🔴 북마크 생성 응답 코드: ${response.statusCode}');
    print('🔴 북마크 생성 응답 바디: ${response.body}');

    final data = jsonDecode(response.body);
    final result = data['result'];

    if ((data['code'] == 0 || data['code'] == 20003) &&
        result != null &&
        result['bookmark_id'] != null) {
      setState(() {
        bookmarkId = result['bookmark_id'];
        bookmarkType = result['target_type'] ?? 'RECRUIT';
        isFavorite = true;
      });

      print('✅ 북마크 생성 성공! ID: $bookmarkId');
      print('✅ 북마크 생성 성공! TYPE: $bookmarkType');

      // 👉 MyPageScreen으로 데이터 반환
      Navigator.pop(context, {
        'bookmark_id': result['bookmark_id'],
        'bookmark_type': result['target_type'] ?? 'RECRUIT',
      });
    } else {
      print('❌ 북마크 생성 실패: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('북마크 등록 실패: ${data['message']}')),
      );
    }
  } catch (e) {
    print('❌ 북마크 등록 예외 발생: $e');
  }
}


  Future<void> deleteBookmark() async {
    if (bookmarkId == null) return;

    final url = Uri.parse(
      'http://43.201.74.44/api/v1/bookmarks/RECRUIT/$bookmarkId',
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': '${widget.token.trim()}',
          'Content-Type': 'application/json',
        },
      );

      print('🧨 DELETE 응답 코드: ${response.statusCode}');
      print('🧨 DELETE 응답 바디: ${response.body}');

      final data = jsonDecode(response.body);

      if (data['code'] == 0 || data['code'] == 20004 || data['code'] == 40404) {
        await fetchRecruitDetail(); // 최신 상태 동기화
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('북마크 삭제 실패: ${data['message']}')),
        );
      }
    } catch (e) {
      print('❌ 북마크 삭제 예외 발생: $e');
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

    final title = recruitData?['recruitName'] ?? '-';
    final deadline = recruitData?['recruitDeadline']?.split('T')[0] ?? '-';
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
            const SizedBox(height: 10),
            Center(
              child: IconButton(
                onPressed: () async {
                  if (isFavorite) {
                    await deleteBookmark();
                  } else {
                    await toggleBookmark();
                  }
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
                const Icon(Icons.business),
                const SizedBox(width: 6),
                Text(company),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 6),
                Text(deadline),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 6),
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
              child: safeImageUrl.isNotEmpty
                  ? Image.network(
                      safeImageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/cat.jpg',
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
                builder: (_) => NavScreens(
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
