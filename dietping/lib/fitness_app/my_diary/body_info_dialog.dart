import 'package:flutter/material.dart';

class BodyInfoDialog extends StatefulWidget {
  final Function(String height, String weight, String gender, String age) onSave;

  const BodyInfoDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _BodyInfoDialogState createState() => _BodyInfoDialogState();
}

class _BodyInfoDialogState extends State<BodyInfoDialog> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = "남성"; // 기본값

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // 배경 색상
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "신체 정보 수정",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF759CE6), // 제목 색상
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "키 (cm)",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black), // 라벨 색상
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "몸무게 (kg)",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "나이",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              crossAxisAlignment: CrossAxisAlignment.center, // 수직 가운데 정렬
              children: [
                Text(
                  "성별:",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 16), // 텍스트와 드롭다운 간격 추가
                DropdownButton<String>(
                  value: _selectedGender,
                  items: ["남성", "여성"]
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _heightController.text,
                  _weightController.text,
                  _selectedGender,
                  _ageController.text,
                );
                Navigator.pop(context);
              },
              child: Text("저장"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF759CE6), // 버튼 색상
                foregroundColor: Colors.white, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }
}
