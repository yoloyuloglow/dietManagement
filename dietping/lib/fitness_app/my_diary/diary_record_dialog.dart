import 'dart:io';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/food_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'food_add_dialog.dart';

class DiaryRecordDialog extends StatefulWidget {
  const DiaryRecordDialog({Key? key}) : super(key: key);

  @override
  _DiaryRecordDialogState createState() => _DiaryRecordDialogState();
}

class _DiaryRecordDialogState extends State<DiaryRecordDialog> {
  String selectedCategory = "아침"; // 기본 선택
  XFile? selectedImage; // 선택된 이미지 파일
  List<XFile> selectedImages = []; // 선택된 이미지 목록
  final ImagePicker picker = ImagePicker(); // 이미지 선택 도구

  // 갤러리 또는 카메라에서 이미지 선택
  Future<void> _selectMultipleImages() async {
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        // 최대 3장의 이미지만 선택
        setState(() {
          selectedImages = images.take(3).toList();
        });
      }
    } catch (e) {
      print("이미지 선택 중 오류 발생: $e");
    }
  }
  Future<void> getImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (selectedImages.length < 3) {
            selectedImages.add(image); // 이미지 추가
          } else {
            print("최대 3장의 이미지만 선택 가능합니다.");
          }
        });
      }
    } catch (e) {
      print("이미지 선택 중 오류 발생: $e");
    }
  }
  /*Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        selectedImage = XFile(pickedFile.path); // 가져온 이미지를 저장
      });
    }
  }*/

  // 이미지 삭제
  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController foodNameController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  color: Color(0xFF0066CC),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 분류 섹션
            Text(
              "분류",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  backgroundColor: Colors.grey[300],
                  selectedColor: Color(0xFF759CE6),
                  labelStyle: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 24),

            // 사진 추가 섹션
            Text(
              "사진 추가",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 선택된 이미지 또는 버튼 표시
            if (selectedImages.isNotEmpty)
              Wrap(
                spacing: 8, // 이미지 간의 수평 간격
                runSpacing: 8, // 이미지 간의 수직 간격
                children: selectedImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final image = entry.value;
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(image.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeImage(index), // 개별 이미지 삭제
                        icon: Icon(Icons.close, color: Colors.red),
                        tooltip: "이미지 삭제",
                      ),
                    ],
                  );
                }).toList(),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconCard(
                    icon: Icons.camera_alt,
                    label: "사진 촬영",
                    onPressed: () async {
                      await getImage(ImageSource.camera); // 카메라로 사진 촬영
                    },
                  ),
                  _buildIconCard(
                    icon: Icons.photo_library,
                    label: "앨범 선택",
                    onPressed: () async {
                      await _selectMultipleImages(); // 갤러리에서 여러 사진 선택
                    },
                  ),
                ],
              ),
            /*if (selectedImage != null)
              Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(selectedImage!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      onPressed: _removeImage,
                      icon: Icon(Icons.close, color: Colors.red),
                      tooltip: "이미지 삭제",
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconCard(
                    icon: Icons.camera_alt,
                    label: "사진 촬영",
                    onPressed: () {
                      getImage(ImageSource.camera); // 카메라로 사진 촬영
                    },
                  ),
                  _buildIconCard(
                    icon: Icons.photo_library,
                    label: "앨범 선택",
                    onPressed: () {
                      getImage(ImageSource.gallery); // 갤러리에서 사진 선택
                    },
                  ),
                ],
              ),*/
            const SizedBox(height: 24),

            // 영양성분 섹션
            Text(
              "영양성분",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconCard(
                  icon: Icons.add,
                  label: "직접 추가",
                  onPressed: () {
                    // "직접 추가" 선택 시 FoodAddDialog 표시
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      // isScrollControlled: true, // 다이얼로그 높이를 키보드와 연동
                      builder: (BuildContext context) {
                        return FoodAddDialog(); // FoodAddDialog 호출
                      },
                    );
                  },
                ),
                _buildIconCard(
                  icon: Icons.search,
                  label: "음식 검색",
                  onPressed: () {
                    // "음식 검색" 선택 시 FoodRecordDialog 표시
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      // isScrollControlled: true, // 다이얼로그 높이를 키보드와 연동
                      builder: (BuildContext context) {
                        return FoodSearchDialog(
                          onDirectAdd: () {
                            // 직접 추가 버튼 동작
                            print("직접 추가 선택");
                            Navigator.pop(context); // 다이얼로그 닫기
                          },
                          onSearch: (String searchText) {
                            // 검색 동작 처리
                            print("검색된 텍스트: $searchText");
                            Navigator.pop(context); // 다이얼로그 닫기
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            const Spacer(),

            // 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("음식명: ${foodNameController.text}");
                  print("분류: $selectedCategory");
                  if (selectedImage != null) {
                    print("저장된 이미지 경로: ${selectedImage!.path}");
                  } else {
                    print("이미지가 선택되지 않았습니다.");
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  padding:
                  EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "저장하기",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodRecordDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: Colors.transparent, // 배경 투명
      isScrollControlled: true, // 키보드 대비 스크롤 가능
      builder: (BuildContext context) {
        return FoodSearchDialog(
          onDirectAdd: () {
            Navigator.pop(context);
            // 직접 추가 동작
            print("직접 추가 버튼 클릭");
          },
          onSearch: (String searchText) {
            Navigator.pop(context);
            // 검색 동작
            // 검색 동작
            print("검색어 입력: $searchText");
          },
        );
      },
    );
  }

  Widget _buildIconCard({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 130,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Color(0xFF0066CC),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
