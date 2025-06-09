import 'package:flutter/material.dart';
import 'package:pc/screens/Complete_screens.dart';

class ProfilesetupScreens extends StatefulWidget {
  const ProfilesetupScreens({super.key});

  @override
  State<ProfilesetupScreens> createState() => _ProfilesetupScreensState();
}

class _ProfilesetupScreensState extends State<ProfilesetupScreens> {
  final TextEditingController majorController = TextEditingController();
  String? selectGrade;
  List<String> selectFields = [];

  @override
  Widget build(BuildContext context) {
    final List<String> gradeOptions = [
      '1학년', '2학년', '3학년', '4학년', '휴학생'
    ];

    final List<String> fields = [
      'IT/소프트웨어 제조업', '공공/정부기관', '교육', '미디어/엔터테인먼트',
      '유통/소매', '농업/식품', '기타 서비스업', '의료/헬스케어',
      '에너지/화학', '건설/부동산', '운송/물류'
    ];

    void toggleField(String field) {
      setState(() {
        if (selectFields.contains(field)) {
          selectFields.remove(field);
        } else {
          selectFields.add(field);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("맞춤형 추천", style: TextStyle(
              color: Color(0xFF7B7B7B), 
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Text("맞춤형 첫 걸음", style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                color: Color(0xFF262626)
              ),
            ),
            Text("여러분들을 위해 추천해드릴게요", style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFF262626)
            ),),
            SizedBox(height: 10,),
            SizedBox(
              width: 372,
              height: 60,
              child: TextFormField(
                controller: majorController,
                decoration: InputDecoration(
                  hintText: '학과',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 372,
              height: 60,
              child: DropdownButtonFormField<String>(
                value: selectGrade,
                hint: const Text('학년 / 학기'),
                items: gradeOptions.map((grade) {
                return DropdownMenuItem(child: Text(grade), value: grade,);
              }).toList(), onChanged: (value) => setState(() => selectGrade = value),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              )
            ),
            const SizedBox(height: 20,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '관심 분야 ', 
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color(0xFF262626),
                        ),
                      ),
                      TextSpan(
                        text: '(복수선택 가능)',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFF262626)
                        )
                      )
                    ]  
                  ),
                ),
                Text('선택 사항', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF262626),
                ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: fields.map((field) {
                final isSelected = selectFields.contains(field);
                return ChoiceChip(
                  label: Text(field),
                  selected: isSelected,
                  onSelected: (_) => toggleField(field),
                  selectedColor: Colors.blue.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: 372,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBBDFFF),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CompleteScreens(),
                    ),
                  );
                }, 
                child: const Text('제출하기', style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1877DD)
                ),), 
                ),
              ),
          ],
        ),
      ),
    );
  }
}