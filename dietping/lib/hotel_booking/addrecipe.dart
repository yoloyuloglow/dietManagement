import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

import '../api/api.dart';
import '../model/loaduser.dart';
import '../model/user.dart';
import 'hotel_home_screen.dart';

class AddRecipe extends StatelessWidget {
  const AddRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 레시피 추가'),
      ),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 조정
      body: AddRecipeForm(),
    );
  }
}

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();

  // 컨트롤러 정의
  final TextEditingController titleController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  List<XFile> selectedImages = []; // 선택된 이미지 목록
  final ImagePicker picker = ImagePicker();
  String? userID;
  String? currentDate; // 오늘 날짜 저장 변수

  @override
  void initState() {
    super.initState();
    _loadUserID(); // 사용자 ID 로드
    _loadCurrentDate(); // 현재 날짜 로드
  }

  // 사용자 ID 로드
  Future<void> _loadUserID() async {
    User? user = await LoadUser.loadUser();
    setState(() {
      userID = user?.user_id;
    });
  }

  // 오늘 날짜 로드
  void _loadCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // 원하는 날짜 형식
    setState(() {
      currentDate = formatter.format(now);
    });
  }

  // 갤러리에서 여러 이미지 선택
  Future<void> _selectMultipleImages() async {
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        setState(() {
          selectedImages = images.take(3).toList();
        });
      }
    } catch (e) {
      print("이미지 선택 중 오류 발생: $e");
    }
  }

  // 카메라에서 이미지 선택
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

  // 서버에 데이터 전송
  Future<void> saveRecipe() async {
    if (userID == null) {
      Fluttertoast.showToast(msg: "유저 ID를 찾을 수 없습니다.");
      return;
    }

    // 필드 값 가져오기 (trim 처리)
    String titleTxt = titleController.text.trim();
    String postTxt = postController.text.trim();
    String ingredientTxt = ingredientController.text.trim();
    String caloriesTxt = caloriesController.text.trim();
    int? calories = caloriesTxt.isNotEmpty ? int.tryParse(caloriesTxt) : null;

    try {
      // 서버 URL 설정
      final url = Uri.parse(API.addrecipe);

      var request = http.MultipartRequest('POST', url);
      request.fields['userid'] = userID!;
      request.fields['title'] = titleTxt;
      request.fields['post'] = postTxt;
      request.fields['ingredient'] = ingredientTxt;
      request.fields['date'] = currentDate!; // 오늘 날짜 추가

      // 선택적 필드
      if (calories != null) {
        request.fields['cal'] = calories.toString();
      }

      // 이미지 추가
      for (var img in selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images', img.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        print("서버 응답 내용: $jsonResponse");
        if (jsonResponse['result'] == true) {
          Fluttertoast.showToast(msg: "레시피 저장 성공");

          // 성공 후 HotelHomeScreen으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HotelHomeScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "레시피 저장 실패: ${jsonResponse['message']}");
        }
      } else {
        print("HTTP 오류 발생: ${response.statusCode}");
        Fluttertoast.showToast(msg: "HTTP 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("요청 중 오류 발생: $e");
      Fluttertoast.showToast(msg: "레시피 저장 중 오류 발생: $e");
    }
  }

  // 이미지 삭제
  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(  // 스크롤 가능하게 설정
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: '제목'),
                validator: (value) => value!.trim().isEmpty ? "제목을 입력하세요" : null,
              ),
              TextFormField(
                controller: postController,
                decoration: InputDecoration(labelText: '내용'),
                validator: (value) => value!.trim().isEmpty ? "내용을 입력하세요" : null,
              ),
              TextFormField(
                controller: ingredientController,
                decoration: InputDecoration(labelText: '재료'),
                validator: (value) => value!.trim().isEmpty ? "재료를 입력하세요" : null,
              ),
              TextFormField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: '칼로리'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // 날짜 표시
              if (currentDate != null)
                Text(
                  "오늘 날짜: $currentDate",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

              SizedBox(height: 20),

              // 사진 추가 섹션
              Text(
                "사진 추가",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // 선택된 이미지 표시
              if (selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
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
                          onPressed: () => _removeImage(index),
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
                        await getImage(ImageSource.camera);
                      },
                    ),
                    _buildIconCard(
                      icon: Icons.photo_library,
                      label: "앨범 선택",
                      onPressed: () async {
                        await _selectMultipleImages();
                      },
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('레시피가 저장 중입니다...')),
                    );

                    await saveRecipe();
                  }
                },
                child: Text('저장하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
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