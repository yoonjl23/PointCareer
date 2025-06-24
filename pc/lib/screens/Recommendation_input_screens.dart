import 'package:flutter/material.dart';
import 'package:pc/screens/Home_screens.dart';
import 'package:pc/screens/Mine_screens.dart';
import 'package:pc/screens/Nav_Screens.dart'; // 그대로 유지되는 import 구문 생략
import 'package:pc/screens/Recommands_screens.dart';

class RecommendationInputScreens extends StatefulWidget {
  final String userId;
  final String token;
  final String userName;

  const RecommendationInputScreens({
    super.key,
    required this.userId,
    required this.token,
    required this.userName,
  });

  @override
  State<RecommendationInputScreens> createState() =>
      _RecommendationInputScreensState();
}

class _RecommendationInputScreensState
    extends State<RecommendationInputScreens> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController pointController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final List<String> interests = [
    'IT/소프트웨어 제조업',
    '공공/정부기관',
    '교육',
    '미디어/엔터테인먼트',
    '유통/소매',
    '농업/식품',
    '기타 서비스업',
    '의료/헬스케어',
    '에너지/화학',
    '건설/부동산',
    '운송/물류',
  ];
  final Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Center(
          child: Text(
            '맞춤형 입력 설정',
            style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xFF7B7B7B),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                '${widget.userName}님의 목표를 향한 첫걸음,',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(
                '간단한 정보를 알려주세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 50),
              Text(
                '지금 필요한 포인트는 몇 점이신가요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pointController,
                decoration: _inputDecoration('ex) 100'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? '* 공란이 불가능합니다.'
                            : null,
              ),
              const SizedBox(height: 20),
              Text(
                '언제까지 포인트를 모으고 싶으신가요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                controller: dateController,
                decoration: _inputDecoration('ex) 2025-12-31T23:59:59'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? '* 공란이 불가능합니다.'
                            : null,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '관심 분야를 알려주세요',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Text('(복수 선택 가능)', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Text(
                    '기존정보 불러오기',
                    style: TextStyle(fontSize: 12, color: Color(0xFFF8991D)),
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    interests.map((item) {
                      final isSelected = selectedInterests.contains(item);
                      return ChoiceChip(
                        label: Text(item),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            isSelected
                                ? selectedInterests.remove(item)
                                : selectedInterests.add(item);
                          });
                        },
                        selectedColor: const Color(0xFFDCEEFF),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? const Color(0xFF007AFF)
                                  : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBDFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => RecommandsScreens(
                                token: widget.token,
                                userId: widget.userId,
                                point: int.parse(pointController.text.trim()),
                                deadline: dateController.text.trim(),
                                interests: selectedInterests.toList(),
                              ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    '추천 결과 받기',
                    style: TextStyle(fontSize: 20, color: Color(0xFF1877DD)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );

  BottomNavigationBar _bottomNav() {
    return BottomNavigationBar(
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
    );
  }
}
