import 'package:flutter/material.dart';

class WaterDialog extends StatefulWidget {
  final int currentIntake;
  final int goalIntake;
  final void Function(int currentIntake, int goalIntake) onSave;

  const WaterDialog({
    Key? key,
    required this.currentIntake,
    required this.goalIntake,
    required this.onSave,
  }) : super(key: key);

  @override
  State<WaterDialog> createState() => _WaterDialogState();
}

class _WaterDialogState extends State<WaterDialog> {
  late TextEditingController _currentIntakeController;
  late TextEditingController _goalIntakeController;

  @override
  void initState() {
    super.initState();
    _currentIntakeController =
        TextEditingController(text: widget.currentIntake.toString());
    _goalIntakeController =
        TextEditingController(text: widget.goalIntake.toString());
  }

  @override
  void dispose() {
    _currentIntakeController.dispose();
    _goalIntakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Center(
              child: Text(
                "물 섭취량 기록",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF759CE6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 섭취량 입력
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "섭취량 (ml):",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _currentIntakeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 목표 섭취량 입력
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "목표 섭취량 (ml):",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _goalIntakeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final int currentIntake =
                      int.tryParse(_currentIntakeController.text) ?? 0;
                  final int goalIntake =
                      int.tryParse(_goalIntakeController.text) ?? 0;

                  widget.onSave(currentIntake, goalIntake);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF759CE6),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text("저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
