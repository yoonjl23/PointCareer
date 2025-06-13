import 'package:flutter/material.dart';
import 'package:pc/db/database_helper.dart';

class MineScreens extends StatelessWidget {
  final String userId;

  const MineScreens({super.key, required this.userId});

  Future<Map<String, dynamic>?> fetchUserInfo() {
    return DatabaseHelper.instance.getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('마이페이지', style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xFF7B7B7B)
            ),),
          ],
        ),
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 70,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/cat.jpg'),
                ),
                const SizedBox(width: 12,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$userId님', style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      color: Color(0xFF262626)
                    ),),
                    Text('산디과 3학년', style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF262626),
                    ),),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('찜한 프로그램/공고', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF262626),
                ),),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('저장된 KGU 프로그램', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF262626),
                ),),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'ex) 맞춤형 입력 설정',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('저장된 추천채용공고', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF262626),
                ),),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'ex) 맞춤형 입력 설정',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}