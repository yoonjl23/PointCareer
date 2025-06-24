import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc/screens/ProfileSetup_screens.dart';

class PhoneauthScreens extends StatefulWidget {
  final String id;
  final String password;
  final String name;

  const PhoneauthScreens({
    super.key,
    required this.id,
    required this.password,
    required this.name,
  });

  @override
  State<PhoneauthScreens> createState() => _PhoneauthScreensState();
}

class _PhoneauthScreensState extends State<PhoneauthScreens> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool codeSent = false;
  String? codeError;
  bool isLoading = false;

  Future<void> _requestCode() async {
    final url = Uri.parse('http://43.201.74.44/api/v1/auth/email/code/request');
    final email = emailController.text.trim();

    try {
      setState(() {
        isLoading = true;
        codeError = null;
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('📩 응답 상태: ${response.statusCode}');
      print('📩 응답 본문: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        try {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            setState(() {
              codeSent = true;
            });
          } else {
            setState(() {
              codeError = data['message'] ?? '인증 요청 실패';
            });
          }
        } catch (e) {
          setState(() {
            codeError = '응답 파싱 오류: $e';
          });
        }
      } else {
        setState(() {
          codeError = '서버 응답이 실패했습니다 (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        codeError = '네트워크 오류: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    final url = Uri.parse('http://43.201.74.44/api/v1/auth/email/code/verify');
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    try {
      setState(() {
        isLoading = true;
        codeError = null;
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'code': code}),
      );

      print('📥 응답 상태: ${response.statusCode}');
      print('📥 응답 본문: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        try {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            _goToProfileSetup();
          } else {
            setState(() {
              codeError = data['message'] ?? '인증 실패';
            });
          }
        } catch (e) {
          setState(() {
            codeError = '응답 파싱 오류: $e';
          });
        }
      } else {
        setState(() {
          codeError = '서버 응답이 실패했습니다 (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        codeError = '네트워크 오류: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToProfileSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilesetupScreens(
          name: widget.name,
          email: emailController.text.trim(),
          loginId: emailController.text.trim(),
          password: widget.password,
          confirmPassword: widget.password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
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
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "가입을 위해 본인의\n이메일을 인증해 주세요.",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 40),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: '이메일 주소 입력',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              '인증번호 코드 입력',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '인증번호 6자리',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            if (codeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  codeError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!codeSent) {
                          await _requestCode();
                        } else {
                          await _verifyCode();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(codeSent ? '인증 완료' : '인증 요청'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
