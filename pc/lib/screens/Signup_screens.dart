import 'package:flutter/material.dart';
import 'package:pc/screens/Phoneauth_screens.dart';
import 'package:pc/screens/Terms_screens.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? passwordError;
  final _formKey = GlobalKey<FormState>();

  void _goToTermsPage() {
    final id = idController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        setState(() {
          passwordError = '비밀번호가 일치하지 않습니다.';
        });
        return;
      }

      // 약관 화면으로 이동, 동의 시 인증 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => TermsScreens(
                onAgree: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PhoneauthScreens(id: id, password: password),
                    ),
                  );
                },
              ),
        ),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: Color(0xFF262626),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    String? errorText,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: SizedBox(
        width: 372,
        height: errorText == null ? 60 : 80,
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: const Color(0xFFE9E9E9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            labelStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            errorText: errorText,
          ),
        ),
      ),
    );
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: idController,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? '이메일을 입력하세요'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'kyonggi@ac.kr',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: passwordController,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
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
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _goToTermsPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFBBDFFF),
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
