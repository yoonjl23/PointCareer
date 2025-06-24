import 'package:flutter/material.dart';
import 'package:pc/screens/Complete_screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilesetupScreens extends StatefulWidget {
  final String name;
  final String email;
  final String loginId;
  final String password;
  final String confirmPassword;

  const ProfilesetupScreens({
    super.key,
    required this.name,
    required this.email,
    required this.loginId,
    required this.password,
    required this.confirmPassword,
  });

  @override
  State<ProfilesetupScreens> createState() => _ProfilesetupScreensState();
}

class _ProfilesetupScreensState extends State<ProfilesetupScreens> {
  final TextEditingController majorController = TextEditingController();
  int? selectGrade;
  String? selectedSemester;
  List<String> selectFields = [];

  void toggleField(String field) {
    setState(() {
      if (selectFields.contains(field)) {
        selectFields.remove(field);
      } else {
        selectFields.add(field);
      }
    });
  }

  Future<void> _submitProfile() async {
    final body = {
      "name": widget.name,
      "email": widget.email,
      "loginId": widget.loginId,
      "password": widget.password,
      "confirmPassword": widget.confirmPassword,
      "major": majorController.text,
      "grade": selectGrade,
      "semester": selectedSemester,
      // "interestFields": selectFields,
      "userPoint": 0,
      "remainPoint": 0
    };

    print("📨 요청 바디: $body");

    final response = await http.post(
      Uri.parse('http://43.201.74.44/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("📨 상태 코드: ${response.statusCode}");
    print("📨 응답 본문: ${response.body}");

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CompleteScreens()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<int> gradeOptions = [1, 2, 3, 4];
    final List<String> semesterOptions = ['1학기', '2학기'];
    final List<String> fields = [
      'IT/소프트웨어 제조업', '공공/정부기관', '교육', '미디어/엔터테인먼트',
      '유통/소매', '농업/식품', '기타 서비스업', '의료/헬스케어',
      '에너지/화학', '건설/부동산', '운송/물류'
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "맞춤형 추천",
              style: TextStyle(
                color: Color(0xFF7B7B7B),
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "맞춤형 첫 걸음",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                  color: Color(0xFF262626),
                ),
              ),
              const Text(
                "여러분들을 위해 추천해드릴게요",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF262626),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 372,
                height: 60,
                child: TextFormField(
                  controller: majorController,
                  decoration: InputDecoration(
                    hintText: '학과',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 372,
                height: 60,
                child: DropdownButtonFormField<int>(
                  value: selectGrade,
                  hint: const Text('학년'),
                  items: gradeOptions.map((grade) {
                    return DropdownMenuItem(
                      child: Text(grade.toString()),
                      value: grade,
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectGrade = value),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 372,
                height: 60,
                child: DropdownButtonFormField<String>(
                  value: selectedSemester,
                  hint: const Text('학기'),
                  items: semesterOptions.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => selectedSemester = value),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '관심 분야 ',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color(0xFF262626),
                          ),
                        ),
                        TextSpan(
                          text: '(복수선택 가능)',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF262626),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '선택 사항',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF262626),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fields.map((field) {
                  final isSelected = selectFields.contains(field);
                  return ChoiceChip(
                    label: Text(field),
                    selected: isSelected,
                    onSelected: (_) => toggleField(field),
                    selectedColor: Colors.blue.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 372,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBDFFF),
                  ),
                  onPressed: _submitProfile,
                  child: const Text(
                    '제출하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1877DD),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
