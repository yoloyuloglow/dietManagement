import 'package:flutter/material.dart';

class FoodRecordDialog extends StatelessWidget {
  final VoidCallback onDirectAdd;
  final Function(String searchText) onSearch;

  const FoodRecordDialog({
    Key? key,
    required this.onDirectAdd,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

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
          color: Colors.white, // Dialog 배경색 흰색으로 설정
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 제목
            Text(
              "음식 기록",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF759CE6), // 제목 색상
              ),
            ),
            const SizedBox(height: 16),
            // 검색 창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "음식 또는 브랜드 이름",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200], // 입력 필드 배경 흰색 계열
                    ),
                    onSubmitted: (value) => onSearch(value),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context), // 닫기 버튼
                  child: Text(
                    "닫기",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 직접 추가 버튼
            ElevatedButton.icon(
              onPressed: onDirectAdd,
              icon: Icon(Icons.add, size: 20),
              label: Text("직접 추가"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF759CE6), // 버튼 배경색
                foregroundColor: Colors.white, // 버튼 텍스트 색상
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 탭 선택 영역
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "최근 먹은"),
                      Tab(text: "직접 추가한"),
                    ],
                    labelColor: Color(0xFF759CE6),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF759CE6),
                  ),
                  const SizedBox(height: 16),
                  // 탭 내용 (예시로 비어 있음)
                  Container(
                    height: 200, // 탭 내용 높이 설정
                    child: TabBarView(
                      children: [
                        Center(
                          child: Text(
                            "최근 먹은 음식이 없습니다.",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Center(
                          child: Text(
                            "직접 추가한 음식이 없습니다.",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
