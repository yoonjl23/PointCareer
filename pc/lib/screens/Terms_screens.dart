import 'package:flutter/material.dart';

class TermsScreens extends StatefulWidget {
  final VoidCallback onAgree;

  const TermsScreens({super.key, required this.onAgree});

  @override
  State<TermsScreens> createState() => _TermsScreensState();
}

class _TermsScreensState extends State<TermsScreens> {
  bool allAgree = false;
  bool termAgree = false;
  bool priaccyAgree = false;
  bool marketingAgree = false;

  String? errorMessage;

  void _toggleAll(bool? value) {
    setState(() {
      allAgree = value ?? false;
      termAgree = allAgree;
      priaccyAgree = allAgree;
      marketingAgree = allAgree;
    });
  }

  void _toggleEach() {
    setState(() {
      allAgree = termAgree && priaccyAgree && marketingAgree;
    });
  }

  void _onAgreePressed() {
    setState(() {
      if (!termAgree || !priaccyAgree) {
        errorMessage = '필수 약관에 모두 동의해야 합니다.';
      } else {
        errorMessage = null;
        widget.onAgree(); // 다음 단계로 이동
      }
    });
  }

  void _showTermsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow({
    required String label,
    required bool value,
    required void Function(bool?) onChanged,
    String? dialogTitle,
    String? dialogContent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF517CF6),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(label),
          ),
        ),
        if (dialogTitle != null && dialogContent != null)
          IconButton(
            icon: Image.asset('assets/images/Vector.png'),
            onPressed: () => _showTermsDialog(dialogTitle, dialogContent),
          ),
      ],
    );
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
          children: [
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "약관 동의",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF262626),
                ),
              ),
            ),
            const SizedBox(height: 40),

            CheckboxListTile(
              activeColor: const Color(0xFF517CF6),
              title: const Text('모두 동의하기'),
              value: allAgree,
              onChanged: _toggleAll,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const Divider(thickness: 1, height: 30, color: Colors.grey),

            _buildCheckRow(
              label: '이용약관(필수)',
              value: termAgree,
              onChanged: (val) {
                setState(() {
                  termAgree = val ?? false;
                  _toggleEach();
                });
              },
              dialogTitle: '서비스 이용약관',
              dialogContent: '여기에 서비스 이용약관 전문이 들어갑니다.',
            ),

            _buildCheckRow(
              label: '개인정보 수집 및 이용 동의(필수수)',
              value: priaccyAgree,
              onChanged: (val) {
                setState(() {
                  priaccyAgree = val ?? false;
                  _toggleEach();
                });
              },
              dialogTitle: '개인정보 수집 및 이용',
              dialogContent: '개인정보 수집 및 이용에 대한 동의 내용입니다.',
            ),

            _buildCheckRow(
              label: '(선택) 이벤트 정보 알림 수신 동의',
              value: marketingAgree,
              onChanged: (val) {
                setState(() {
                  marketingAgree = val ?? false;
                  _toggleEach();
                });
              },
              dialogTitle: '마케팅 수신 동의',
              dialogContent: '이벤트 및 혜택 정보를 수신하시겠습니까?',
            ),

            const SizedBox(height: 10),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onAgreePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("다음"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
