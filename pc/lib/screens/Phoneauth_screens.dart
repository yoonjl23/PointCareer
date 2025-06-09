import 'package:flutter/material.dart';
import 'package:pc/db/database_helper.dart';
import 'package:pc/screens/Login_screens.dart';
import 'package:pc/screens/ProfileSetup_screens.dart';

class PhoneauthScreens extends StatefulWidget {
  final String id;
  final String password;

  const PhoneauthScreens({
    super.key,
    required this.id,
    required this.password,
  });

  @override
  State<PhoneauthScreens> createState() => _PhoneauthScreensState();
}

class _PhoneauthScreensState extends State<PhoneauthScreens> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool codeSent = false;
  String? codeError;

  Future<void> _completeSignup() async {
    final result = await DatabaseHelper.instance.insertUser(widget.id, widget.password);
    if (result > 0) {
      print('✅ 회원가입 성공: ${widget.id}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilesetupScreens()),
      );
    } else {
      setState(() {
        codeError = '이미 등록된 아이디입니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "이메일 인증",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "가입을 위해 본인의\n휴대폰 번호를 인증해 주세요.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),

            // 휴대폰 번호 입력
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: '휴대폰 번호',
                hintText: '01012345678',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFE9E9E9),
              ),
            ),
            const SizedBox(height: 16),

            // 인증번호 입력
            if (codeSent)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '인증번호 입력',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE9E9E9),
                    ),
                  ),
                  if (codeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        codeError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 24),

            // 인증 요청 / 인증 완료 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (!codeSent) {
                    setState(() {
                      codeSent = true;
                      codeError = null;
                    });
                  } else {
                    final code = codeController.text.trim();
                    if (code == "123456") {
                      await _completeSignup();
                    } else {
                      setState(() {
                        codeError = '인증번호가 올바르지 않습니다.';
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(codeSent ? '인증 완료' : '인증 요청'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
