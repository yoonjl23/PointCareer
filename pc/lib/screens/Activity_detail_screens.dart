import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Nav_Screens.dart';
import 'package:url_launcher/url_launcher.dart';
// 상단 import 생략

class ActivityDetailScreens extends StatefulWidget {
  final String userId;
  final String token;
  final int pointId;

  const ActivityDetailScreens({
    super.key,
    required this.userId,
    required this.token,
    required this.pointId,
  });

  @override
  State<ActivityDetailScreens> createState() => _ActivityDetailScreensState();
}

class _ActivityDetailScreensState extends State<ActivityDetailScreens> {
  Map<String, dynamic>? pointData;
  bool isLoading = true;
  bool isFavorite = false;
  int? bookmarkId;

  @override
  void initState() {
    super.initState();
    fetchPointDetail();
  }

  Future<void> fetchPointDetail() async {
    try {
      final url = Uri.parse(
        'http://43.201.74.44/api/v1/points/activities/${widget.pointId}',
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
        final point = decoded['result']['point'];
        final bookmark = decoded['result']['bookmark'];

        setState(() {
          pointData = point;
          if (bookmark != null &&
              bookmark is Map &&
              bookmark['bookmark_id'] != null) {
            bookmarkId = bookmark['bookmark_id'];
            isFavorite = true;
          } else {
            bookmarkId = null;
            isFavorite = false;
          }
          isLoading = false;
        });
      } else {
        throw Exception('포인트 활동 정보를 불러오지 못했습니다.');
      }
    } catch (e) {
      print('❌ 에러: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleBookmark() async {
  final url = Uri.parse('http://43.201.74.44/api/v1/bookmarks');
  final body = jsonEncode({'id': widget.pointId, 'target_type': 'POINT'});

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
        isFavorite = true;
      });

      print('✅ 북마크 생성 성공! ID: $bookmarkId');

      // 👉 MyPageScreen으로 데이터 반환
      Navigator.pop(context, {
        'bookmark_id': result['bookmark_id'],
        'bookmark_type': result['target_type'] ?? 'POINT',
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
      'http://43.201.74.44/api/v1/bookmarks/POINT/$bookmarkId',
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
        await fetchPointDetail(); // 최신 상태 동기화
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('북마크 삭제 실패: ${data['message']}')),
        );
      }
    } catch (e) {
      print('❌ 북마크 삭제 예외 발생: $e');
    }
  }

  // --- 아래 UI 렌더링 부분 생략 없이 포함됨 ---

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (pointData == null) {
      return const Scaffold(body: Center(child: Text('데이터를 불러오지 못했습니다.')));
    }

    final title = pointData?['point_title'] ?? '-';
    final start =
        (pointData?['point_start_time'] as String?)?.split('T').first ?? '-';
    final end =
        (pointData?['point_end_time'] as String?)?.split('T').first ?? '-';
    final field =
        (pointData?['favoriteCategories'] as List?)?.join(', ') ?? '-';
    final category =
        (pointData?['activityCategories'] as List?)?.join(', ') ?? '-';
    final imageUrl = pointData?['point_image_url'] ?? '';
    final location = pointData?['point_place'] ?? '-';
    final point = '${pointData?['point_price'] ?? '-'}P';
    final type = pointData?['point_online_type'] == 'ONLINE' ? '온라인' : '오프라인';
    final duration = '${pointData?['point_duration'] ?? '-'}시간';
    final applyUrl = pointData?['point_link_url'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'KGU 프로그램',
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
                  await fetchPointDetail(); // 🔄 최신 상태로 UI 갱신
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
                const Icon(Icons.calendar_month, size: 18),
                const SizedBox(width: 6),
                Text('$start ~ $end', style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 6),
                Text(location, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '두 줄 요약',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(point),
                const Text('주고'),
                _buildChip(type),
                const Text('에서'),
                _buildChip(duration),
                const Text('진행돼요!'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(
                  field,
                  color: const Color(0xFFEAF1FF),
                  textColor: const Color(0xFF3C6BDB),
                ),
                const Text('분야의'),
                _buildChip(
                  category,
                  color: const Color(0xFFEAF1FF),
                  textColor: const Color(0xFF3C6BDB),
                ),
                const Text('활동입니다.'),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Image.asset(
                              'assets/images/cat.jpg',
                              height: 200,
                              fit: BoxFit.cover,
                            ),
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
                onPressed: () {
                  if (applyUrl.isNotEmpty) {
                    launchLink(applyUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('신청 링크가 없습니다.')),
                    );
                  }
                },
                child: const Text(
                  '신청하러 가기',
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
    );
  }

  Widget _buildChip(
    String label, {
    Color color = const Color(0xFFEAF1FF),
    Color textColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }

  Future<void> launchLink(String url) async {
    try {
      if (url.isEmpty) throw Exception('빈 링크입니다.');
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('URL 실행 실패: $url');
      }
    } catch (e) {
      print('❌ URL 실행 에러: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('유효하지 않은 링크입니다.')));
    }
  }
}
