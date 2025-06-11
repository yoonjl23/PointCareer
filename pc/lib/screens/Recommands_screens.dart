import 'package:flutter/material.dart';

class RecommandsScreens extends StatelessWidget {
  const RecommandsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('맞춤형 추천', style: TextStyle(
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
    );
  }
}