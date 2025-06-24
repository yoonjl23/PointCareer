import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Signup_screens.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool saveId = false;
  String? loginError;

  Future<void> _login() async {
    setState(() {
      loginError = null;
    });

    final id = studentIdController.text.trim();
    final password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      setState(() {
        loginError = '아이디와 비밀번호를 모두 입력하세요.';
      });
      return;
    }

    final url = Uri.parse('http://43.201.74.44/api/v1/auth/login');

    try {
      print('📡 로그인 요청 시작');
      print('➡️ 입력된 ID: $id');
      print('➡️ 입력된 PW: $password');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'loginId': id, 'password': password}),
      );

      print('📥 응답 상태 코드: ${response.statusCode}');
      print('📥 응답 본문: ${response.body}');

      final data = jsonDecode(response.body);
      final headers = response.headers;

      if (response.statusCode == 200 && data['status'] == 'success') {
        final userId = data['result']['user_id'].toString();
        final accessToken = headers['authorization']; // 소문자로 자동 변환됨
        final refreshToken = headers['authorization_refresh'];

        print('✅ 로그인 성공 - userId: $userId');
        print('🔐 accessToken: $accessToken');
        print('🔄 refreshToken: $refreshToken');

        if (accessToken == null || refreshToken == null) {
          setState(() {
            loginError = '서버에서 토큰을 받지 못했습니다.';
          });
          return;
        }

        // 다음 화면으로 이동
        print('🧪 넘기는 userId: $userId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NavScreens(token: accessToken, userId: userId),
          ),
        );
      } else {
        setState(() {
          loginError = data['message'] ?? '아이디 또는 비밀번호가 잘못되었습니다.';
        });
        print('❌ 로그인 실패: ${data['message']}');
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      setState(() {
        loginError = '서버 오류: 네트워크를 확인하세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              '경기대생을 위한\n똑똑한 포인트 관리 & 채용정보 서비스',
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 18 * -0.03,
                color: Color(0xFF7B7B7B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image(
                    image: AssetImage('assets/images/clouds.png'),
                    width: 56,
                    height: 56,
                  ),
                ),
                Text(
                  'PointCareer',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            // ID 입력
            SizedBox(
              width: 372,
              height: 60,
              child: TextFormField(
                controller: studentIdController,
                decoration: InputDecoration(
                  hintText: 'sample@kgu.ac.kr',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // PW 입력
            SizedBox(
              width: 372,
              height: 60,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            if (loginError != null)
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    loginError!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ),

            const SizedBox(height: 19),

            // 로그인 버튼
            SizedBox(
              width: 372,
              height: 60,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFE2E2E2),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 회원가입 버튼
            SizedBox(
              width: 372,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreens(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7B7B7B),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // 저장 ID 체크박스
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: saveId,
                    onChanged: (bool? value) {
                      setState(() {
                        saveId = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF517CF6),
                    title: const Text(
                      "Saved ID",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
