import 'package:flutter/material.dart';
import 'package:pc/screens/Login_screens.dart';

class LoadingScreens extends StatefulWidget {
  const LoadingScreens({super.key});

  @override
  State<LoadingScreens> createState() => _LoadingScreensState();
}

class _LoadingScreensState extends State<LoadingScreens> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreens()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.1),
            radius: 1.5,
            colors: [
              Color(0xFF62B7FF).withOpacity(0.5),
              Color(0xFFFFFFFF).withOpacity(0.5),
              Color(0xFFFFDCB5).withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),

            const SizedBox(height: 70),
            const Text(
              '의미없는 포인트 활동으로\n시간 낭비하고 있나요?',
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 24,
                letterSpacing: 24 * -0.03,
                color: Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/3D_ICON1.png',
                width: 160.2,
                height: 160.2,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "진로와 연결된 활동으로\n포인트도 채우고 경력도 쌓아요",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w900,
                fontSize: 27,
                letterSpacing: 27 * -0.03,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/images/clouds.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                const Text(
                  'PointCareer',
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Color(0xFF262626),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Text(
              "경기대생을 위한\n똑똑한 포인트 관리 & 채용 정보 서비스",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 18 * -0.03,
                color: Color(0xFF7B7B7B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
