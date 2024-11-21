import 'package:flutter/material.dart';

class MealSelectionDialog extends StatelessWidget {
  final VoidCallback onTextRecord;
  final VoidCallback onTakePhoto;
  final VoidCallback onFindInAlbum;
  final VoidCallback onRecordNutrients; // 추가된 필드

  const MealSelectionDialog({
    Key? key,
    required this.onTextRecord,
    required this.onTakePhoto,
    required this.onFindInAlbum,
    required this.onRecordNutrients, // 추가된 필드 초기화
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: Color(0xFF759CE6), // 주요 색상
        hintColor: Color(0xFF759CE6), // 힌트 색상
        colorScheme: ColorScheme.light(primary: Color(0xFF759CE6)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF759CE6), // 버튼 배경색
            foregroundColor: Colors.white, // 버튼 텍스트 및 아이콘 색상
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Dialog 배경색
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
          children: [
            Text(
              "오늘의 식단 기록",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF759CE6), // 제목 색상
              ),
            ),
            const SizedBox(height: 16),
            // 버튼들 (Grid를 사용하여 동일 크기 유지)
            GridView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 행에 두 개의 버튼
                mainAxisSpacing: 16, // 버튼 간 상하 간격
                crossAxisSpacing: 16, // 버튼 간 좌우 간격
                childAspectRatio: 1.2, // 버튼 비율 (넓이/높이)
              ),
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.text_fields,
                  label: "텍스트 기록",
                  onPressed: onTextRecord, // 여기에 연결
                ),
                _buildOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: "사진 촬영",
                  onPressed: onTakePhoto,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.photo,
                  label: "앨범에서 찾기",
                  onPressed: onFindInAlbum,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.pie_chart,
                  label: "영양성분 기록",
                  onPressed: onRecordNutrients, // 여기에 연결
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200], // 버튼 배경색
        foregroundColor: Color(0xFF759CE6), // 아이콘 및 텍스트 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Color(0xFF759CE6)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF759CE6)),
          ),
        ],
      ),
    );
  }
}
