import 'package:flutter/material.dart';
import 'package:pc/screens/Nav_Screens.dart';

class ActivityDetailScreens extends StatefulWidget {
  final String userId;
  final String title;
  final String imagePath;
  final String point;
  final String type;
  final String duration;
  final String field;
  final String category;
  final String date;
  final String location;

  const ActivityDetailScreens({
    super.key,
    required this.userId,
    required this.title,
    required this.imagePath,
    required this.point,
    required this.type,
    required this.duration,
    required this.field,
    required this.category,
    required this.date,
    required this.location,
  });

  @override
  State<ActivityDetailScreens> createState() => _ActivityDetailScreensState();
}

class _ActivityDetailScreensState extends State<ActivityDetailScreens> {
  bool isFavorite = false; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('KGU 프로그램',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color(0xFF7B7B7B),
                )),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Center(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
              }, icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                size: 28,
                color: Color(0xFF1877DD),
              )),
            ),
            const SizedBox(height: 20),
            Text(widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto",
                color: Color(0xFF262626)
              ),
            ),
            const SizedBox(height: 12),

            Row(children:  [
              Icon(Icons.calendar_month, size: 18),
              SizedBox(width: 6),
              Text(widget.date, style: TextStyle(fontSize: 14)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 18),
              SizedBox(width: 6),
              Text(widget.location, style: TextStyle(fontSize: 14)),
            ]),
            const SizedBox(height: 20),

            const Text('두 줄 요약',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('${widget.point}'),
                Text('주고', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.42
                ),),
                _buildChip(widget.type),
                Text('에서', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.42
                ),),
                _buildChip(widget.duration),
                Text('진행돼요!', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.42
                ),),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildChip('${widget.field}', color: Color(0xFFEAF1FF), textColor: Color(0xFF3C6BDB)),
                const Text('분야의', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.42
                ),),
                _buildChip('${widget.category}', color: Color(0xFFEAF1FF), textColor: Color(0xFF3C6BDB)),
                const Text('할 수 있는 활동입니다.', style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.42
                ),),
              ],
            ),
            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6E7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: 신청 로직
                },
                child: const Text(
                  '신청하러가기',
                  style: TextStyle(
                    color: Color(0xFF1877DD),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2),
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NavScreens(token: widget.userId, initialIndex: index),
            ),
          );
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF7B7B7B),
        unselectedItemColor: const Color(0xFF7B7B7B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {Color color = const Color(0xFFEAF1FF), Color textColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }
}
