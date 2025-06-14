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
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => const LoginScreens()));
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
            ]
          )
        ),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset('assets/images/clouds.png', width: 40, height: 40,),
                ),
                const Text(
                  'PointCareer',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ), const SizedBox(height: 70,),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "완벽한 ",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto",
                      color: Color(0xFF262626),
                    )
                  ),
                  TextSpan(
                    text: "졸업",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto",
                      color: Color(0xFF1877DD),
                    )
                  )
                ]
              )
            ), 
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "완벽한 ",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto",
                      color: Color(0xFF262626),
                    )
                  ),
                  TextSpan(
                    text: "준비",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto",
                      color: Color(0xFF1877DD),
                    )
                  )
                ]
              )
            ),
            const Text("나에게 딱 맞는 프로그램을 추천 받으세요!", style: TextStyle(
              fontSize: 20,
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/3D_ICON1.png', width: 300, height: 300,),
            ),
            const SizedBox(height: 50,),
            const Text("KGU포인트를 채워야 하는 경기대생 대상", style: TextStyle(
              fontSize: 18,
            ),),
            Text("경기대에서 받을 수 있는 추천 채용", style: TextStyle(
              fontSize: 18,
            ),)
          ],
          
        ),
      ),
    );
  }
}