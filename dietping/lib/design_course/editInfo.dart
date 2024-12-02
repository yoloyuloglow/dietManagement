import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/loaduser.dart';
import '../model/user.dart';
import '../api/api.dart';

class UserEditScreen extends StatefulWidget {
  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController kcalController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    User? user = await LoadUser.loadUser();
    final url = Uri.parse(API.loadUser);
    try {
      final response = await http.post(
        url,
        body: {
          "userid": user?.user_id ?? '',
        },
      );

      if (response.statusCode == 200) {
        final userInfo = json.decode(response.body);
        if (userInfo['result'] == 'true') {
          setState(() {
            nicknameController.text = userInfo['user_info'][0][0]?.toString() ?? '';
            kcalController.text = userInfo['user_info'][0][1]?.toString() ?? '0';
            heightController.text = userInfo['user_info'][0][2]?.toString() ?? '0.0';
            weightController.text = userInfo['user_info'][0][3]?.toString() ?? '0.0';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("유저 정보 불러오기 성공")),
          );
        }
      } else {
        throw Exception("Failed to load user information.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> updateUserInfo() async {
    // 입력값 검증
    if (nicknameController.text.trim().isEmpty ||
        kcalController.text.trim().isEmpty ||
        heightController.text.trim().isEmpty ||
        weightController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("모든 필드를 입력해주세요.")),
      );
      return;
    }

    User? user = await LoadUser.loadUser();
    final url = Uri.parse(API.updateUser); // 수정할 정보 전달하는 API

    try {
      final response = await http.post(
        url,
        body: {
          "userid": user?.user_id ?? '',
          "nickname": nicknameController.text.trim(),
          "kcal": kcalController.text.trim(),
          "height": heightController.text.trim(),
          "weight": weightController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['result'] == 'true') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("정보 수정 성공")),
          );
          Navigator.pop(context); // 이전 화면으로 돌아감
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("정보 수정 실패: ${result['message']}")),
          );
        }
      } else {
        throw Exception("Failed to update user information.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 정보 수정하기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nicknameController,
                decoration: InputDecoration(labelText: "닉네임"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid nickname";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: kcalController,
                decoration: InputDecoration(labelText: "목표 칼로리"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return "Please enter a valid calorie target";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: heightController,
                decoration: InputDecoration(labelText: "키 (cm)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return "Please enter a valid height";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(labelText: "몸무게 (kg)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return "Please enter a valid weight";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUserInfo(); // 정보 수정 API 호출
                  }
                },
                child: Text("정보 변경하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}