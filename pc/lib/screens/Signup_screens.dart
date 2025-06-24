import 'package:flutter/material.dart';
import 'package:pc/screens/Phoneauth_screens.dart';
import 'package:pc/screens/Terms_screens.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? passwordError;
  final _formKey = GlobalKey<FormState>();

  void _goToTermsPage() {
    final name = nameController.text.trim();
    final id = idController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      passwordError = null;
    });

    // 🔍 디버깅용 출력
    print('🧪 입력한 비밀번호: $password');
    print('🧪 비밀번호 확인: $confirmPassword');

    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        setState(() {
          passwordError = '비밀번호가 일치하지 않습니다.';
        });
        print('❌ 비밀번호 불일치');
        return;
      }

      print('✅ 비밀번호 일치');

      // 약관 화면 → 동의하면 인증 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermsScreens(
            onAgree: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhoneauthScreens(id: id, password: password, name: name,),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 19),
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // 이름 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '이름을 입력하세요'
                        : null,
                    decoration: InputDecoration(
                      hintText: '김경기',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),

              // 아이디 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: idController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '아이디를 입력하세요'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'kyonggi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),

              // 비밀번호 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '비밀번호를 입력하세요'
                        : null,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  '영문 대소문자/숫자/특수문자 중 2가지 이상 조합, 8자~32자',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFC4C4C4),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // 비밀번호 확인 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '비밀번호를 입력하세요'
                        : null,
                    decoration: InputDecoration(
                      hintText: '비밀번호 재확인',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                ),
              ),

              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 5),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 150),

              // 다음 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _goToTermsPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBDFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(fontSize: 24, color: Color(0xFF1877DD)),
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
