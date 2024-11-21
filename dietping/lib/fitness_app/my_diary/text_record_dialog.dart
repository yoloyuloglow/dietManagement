import 'package:flutter/material.dart';

class TextRecordDialog extends StatefulWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onSelectFromAlbum;
  final VoidCallback onAddDirectly;
  final VoidCallback onSearchFood;

  const TextRecordDialog({
    Key? key,
    required this.onTakePhoto,
    required this.onSelectFromAlbum,
    required this.onAddDirectly,
    required this.onSearchFood,
  }) : super(key: key);

  @override
  _TextRecordDialogState createState() => _TextRecordDialogState();
}

class _TextRecordDialogState extends State<TextRecordDialog> {
  String selectedCategory = "아침"; // 기본 선택

  @override
  Widget build(BuildContext context) {
    TextEditingController foodNameController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.66, // 화면의 2/3 차지
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Center(
                child: Text(
                  "${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일 식단",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF759CE6), // 이미지의 주요 색상
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 음식명 입력
              TextField(
                controller: foodNameController,
                decoration: InputDecoration(
                  hintText: "음식명을 입력하세요",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 분류 선택
              Text(
                "분류",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["아침", "점심", "저녁"]
                    .map(
                      (category) => ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Color(0xFF759CE6),
                    labelStyle: TextStyle(
                      color: selectedCategory == category
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 16),
              // 사진 추가 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onTakePhoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text("사진 촬영"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF759CE6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.onSelectFromAlbum,
                    icon: Icon(Icons.photo),
                    label: Text("앨범에서 선택"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF759CE6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 영양성분 추가 버튼
              Text(
                "영양성분",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.onAddDirectly,
                    child: Text("직접 추가"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF759CE6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.onSearchFood,
                    child: Text("음식 검색으로 추가"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF759CE6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 저장 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("음식명: ${foodNameController.text}");
                    print("분류: $selectedCategory");
                    Navigator.pop(context);
                  },
                  child: Text("저장하기"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF759CE6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
