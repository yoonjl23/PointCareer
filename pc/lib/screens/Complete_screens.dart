import 'package:flutter/material.dart';
import 'package:pc/screens/Login_screens.dart';

class CompleteScreens extends StatefulWidget {
  const CompleteScreens({super.key});

  @override
  State<CompleteScreens> createState() => _CompleteScreensState();
}

class _CompleteScreensState extends State<CompleteScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // 전체 너비
        height: double.infinity, // 전체 높이
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFF62B7FF).withOpacity(0.3),
              const Color(0xFFFFFFFF).withOpacity(0.3),
              const Color(0xFFFFDCB5).withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              const SizedBox(height: 168,),
              const Text(
                '회원가입 완료!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '나에게 맞는 활동부터 추천 채용정보까지\n포인커리어에서 모두 확인하세요',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 66,),
              Padding(
                padding: const EdgeInsets.only(left: 69),
                child: Image(
                  image: AssetImage('assets/images/3D_ICON2.png'),
                  width: 273,
                  height: 273,
                ),
              ),
              const SizedBox(height: 105,),
              SizedBox(
                width: 372,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreens()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBDFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: const Text('시작하기', style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Color(0xFF1877DD),
                  ),)),
              )
            ],
            
          ),
        ),
      ),
    );
  }
}
