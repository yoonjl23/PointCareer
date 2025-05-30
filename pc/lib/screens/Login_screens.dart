import 'package:flutter/material.dart';
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

  void _login() {
    final id = studentIdController.text;
    final password = passwordController.text;

    print('$id');
    print('$password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int Index) {
          print('$Index');
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Home.png', width: 35, height: 35,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/User_cicrle.png', width: 35, height: 35,),
            label: '',
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 168,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Image.asset('assets/images/clouds.png', width: 56, height: 56,),
              ),
              const Text(
                'PointCareer',
                style: TextStyle(fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.w700),
              ),
            ]
          ),
          const SizedBox(height: 10,),

          SizedBox(
            width: 372,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE9E9E9),
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
          SizedBox(height: 10,),
          SizedBox(
            width: 372,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE9E9E9),
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
          const SizedBox(height: 19,),

          SizedBox(
            width: 372,
            height: 60,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF555555),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              child: const Text(
                '로그인', style: TextStyle(fontSize: 18, color: Color(0xFFE2E2E2), fontFamily: 'Roboto'),
              )),
          ),
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
                  activeColor: Color(0xFF517CF6),
                  title: const Text("Saved ID", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),),
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SignupScreens()),
                  );
              }, child: const Text("회원가입", style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Color(0xFF9D9D9D),
              ),),)
            ],
          ),

            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text("-아이디는 학번입니다.", style: TextStyle(
                  fontSize: 18, fontFamily: 'Roboto', color: Color(0xFF9D9D9D)
                ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text("-경기대학생분들의 KGU+ 포인트적립을\n도와드릴게요!", style: TextStyle(
                  fontSize: 18, fontFamily: 'Roboto', color: Color(0xFF9D9D9D)
                ),),
              ),
            )
        ],
      ),
    );
  }
}