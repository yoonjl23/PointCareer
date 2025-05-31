import 'package:flutter/material.dart';
import 'package:pc/screens/Signup_screens.dart';
import 'package:pc/db/database_helper.dart';
import 'Main_screens.dart';

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


    if (id.isEmpty || password.isEmpty) {
      setState(() {
        loginError = '아이디와 비밀번호를 모두 입력하세요.';
      });
      return;
    }

    final db = DatabaseHelper.instance;
    bool success = await db.verifyUser(id, password);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreens()),
      );
    } else {
      setState(() {
        loginError = '아이디 또는 비밀번호가 잘못되었습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          print('탭 선택: $index');
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/images/Home.png'), width: 35, height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/images/User_cicrle.png'), width: 35, height: 35),
            label: '',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 168),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Image(image: AssetImage('assets/images/clouds.png'), width: 56, height: 56),
              ),
              const Text(
                'PointCareer',
                style: TextStyle(fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 학번 입력
          SizedBox(
            width: 372,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: '20110532',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF262626),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 비밀번호 입력
          SizedBox(
            width: 372,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: '비밀번호(password)',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF262626),
                  ),
                ),
              ),
            ),
          ),

          // 로그인 실패 메시지
          if (loginError != null)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loginError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
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
                backgroundColor: const Color(0xFF555555),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(fontSize: 18, color: Color(0xFFE2E2E2), fontFamily: 'Roboto'),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreens()),
                  );
                },
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9D9D9D),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "-아이디는 학번입니다.",
                style: TextStyle(fontSize: 18, fontFamily: 'Roboto', color: Color(0xFF9D9D9D)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "-경기대학생분들의 KGU+ 포인트적립을\n도와드릴게요!",
                style: TextStyle(fontSize: 18, fontFamily: 'Roboto', color: Color(0xFF9D9D9D)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
