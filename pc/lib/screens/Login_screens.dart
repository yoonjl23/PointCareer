import 'package:flutter/material.dart';
import 'package:pc/screens/Nav_Screens.dart';
import 'package:pc/screens/Signup_screens.dart';
import 'package:pc/db/database_helper.dart';
import 'Mine_screens.dart';

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

  void _login() async {
    setState(() {
      loginError = null;
    });

    final id = studentIdController.text.trim();
    final password = passwordController.text.trim();

    print('🧪 입력된 ID: $id');
    print('🧪 입력된 PW: $password');

    if (id.isEmpty || password.isEmpty) {
      setState(() {
        loginError = '아이디와 비밀번호를 모두 입력하세요.';
      });
      return;
    }

    final db = DatabaseHelper.instance;

    // 디버깅용 전체 사용자 출력
    await db.debugPrintAllUsers();

    bool success = await db.verifyUser(id, password);

    if (success) {
      print('✅ 로그인 성공: $id');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavScreens(userId: id)),
      );
    } else {
      print('❌ 로그인 실패');
      setState(() {
        loginError = '아이디 또는 비밀번호가 잘못되었습니다.';
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
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image(
                    image: AssetImage('assets/images/clouds.png'),
                    width: 56,
                    height: 56,
                  ),
                ),
                const Text(
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

            // 학번 입력
            SizedBox(
              width: 372,
              height: 60,
              child: TextFormField(
                controller: studentIdController,
                decoration: InputDecoration(
                  hintText: 'sample@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: false,
              ),
            ),

            const SizedBox(height: 10),

            // 비밀번호 입력
            SizedBox(
              width: 372,
              height: 60,
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '영문, 숫자, 특수문자 포함 8자 이상',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
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

            // 저장 및 회원가입
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

  Widget _buildInputField(
    TextEditingController controller,
    IconData icon,
    String label,
    bool obscure,
  ) {
    return SizedBox(
      width: 372,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon),
            labelText: label,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
          ),
        ),
      ),
    );
  }
}
