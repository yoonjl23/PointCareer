import 'package:flutter/material.dart';
import 'package:pc/db/database_helper.dart';
import 'package:pc/screens/Phoneauth_screens.dart';
import 'package:pc/screens/Terms_screens.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? passwordError; // ✅ 에러 메시지 상태
  final _formKey = GlobalKey<FormState>();

  void _signUp() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

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

      final db = DatabaseHelper.instance;
      bool exists = await db.emailExists(email);
      if (exists) {
        setState(() {
          passwordError = '이미 등록된 이메일입니다.';
        });
        return;
      }

      int result = await db.insertUser(email, password);
      if (result != -1) {
        Navigator.pop(context);
      } else {
        setState(() {
          passwordError = '회원가입 실패 (오류)';
        });
      }
    }
  }

  void _goToTermsPage() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermsScreens(
            onAgree: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PhoneauthScreens()),
              );
            },
          ),
        ),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 19, bottom: 5),
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
    String? errorText, // ✅ 추가
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: SizedBox(
        width: 372,
        height: errorText == null ? 60 : 80, // 에러 메시지 표시 공간 확보
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
            errorText: errorText, // ✅ 여기서 보여짐
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          print('탭 선택: $index');
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/images/Home.png'),
              width: 35,
              height: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/images/User_cicrle.png'),
              width: 35,
              height: 35,
            ),
            label: '',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              const Padding(
                padding: EdgeInsets.only(left: 19),
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
              _buildLabel("이메일"),
              _buildTextField(
                label: "email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  return null;
                },
              ),
              _buildLabel("비밀번호"),
              _buildTextField(
                label: "password",
                controller: passwordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요.';
                  }
                  return null;
                },
              ),
              _buildLabel("비밀번호 확인"),
              _buildTextField(
                label: "confirm password",
                controller: confirmPasswordController,
                obscure: true,
                errorText: passwordError, // ✅ 여기 적용
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호 확인을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 372,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _goToTermsPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
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
