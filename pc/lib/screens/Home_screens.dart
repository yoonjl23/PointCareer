import 'package:flutter/material.dart';
import 'package:pc/screens/Login_screens.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
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
      backgroundColor: Color(0xFFF2F2F2),
      body: Column(
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
          const Text("완벽한 졸업", style: TextStyle(
            fontSize: 36, fontWeight: FontWeight.w800,
          ),), 
          const Text ("완벽한 준비", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,),),
          const Text("나에게 딱 맞는 프로그램을 추천 받으세요!", style: TextStyle(
            fontSize: 20,
          ),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/clouds.png', width: 300, height: 300,),
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
    );
  }
}