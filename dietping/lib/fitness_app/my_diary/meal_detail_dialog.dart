import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../model/loaduser.dart';
import '../../model/user.dart';
import '../my_diary/my_diary_screen.dart'; // 메인 화면 import

class MealDetailDialog extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> foodinfo;
  final int kcal;
  final DateTime selectedDate;

  const MealDetailDialog({
    Key? key,
    required this.title,
    required this.foodinfo,
    required this.kcal,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _MealDetailDialogState createState() => _MealDetailDialogState();
}

class _MealDetailDialogState extends State<MealDetailDialog> {
  bool isLoading = false;

// 삭제 및 기록 업데이트 후 메인 화면으로 이동
  /*Future<void> _deleteMealAndGoToMain() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 삭제 요청
      print("삭제 요청 시작: 시간대 ${widget.title}, 날짜 ${widget.selectedDate}");
      bool deleteSuccess = await _deleteMealFromServer();
      print("삭제 요청 결과: $deleteSuccess");

      if (deleteSuccess != true) {
        Fluttertoast.showToast(msg: "삭제 실패");
        return;
      }

      // widget.foodinfo 디버깅
      print("삭제 이전 foodinfo: ${widget.foodinfo}");

      // widget.foodinfo에서 삭제된 식단 제거
      List<Map<String, dynamic>> updatedFoodInfo = widget.foodinfo.where((food) {
        return food['time'] != widget.title; // 삭제된 시간대 제외
      }).toList();

      // 삭제 후 데이터 확인
      print("삭제 후 updatedFoodInfo: $updatedFoodInfo");

      // 기록 업데이트 요청
      bool updateSuccess = await _updateRecordDB(updatedFoodInfo);
      print("기록 업데이트 결과: $updateSuccess");

      if (!updateSuccess) {
        Fluttertoast.showToast(msg: "기록 업데이트 실패");
        return;
      }

      // 성공 시 메인 화면으로 이동
      Fluttertoast.showToast(msg: "삭제 및 업데이트 완료");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyDiaryScreen()),
            (Route<dynamic> route) => false, // 이전 화면 제거
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "오류 발생: $e");
      print("삭제 및 업데이트 중 오류 발생: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }*/

  Future<void> _deleteMealAndGoToMain() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 삭제 요청
      print("삭제 요청 시작: 시간대 ${widget.title}, 날짜 ${widget.selectedDate}");
      bool deleteSuccess = await _deleteMealFromServer();
      print("삭제 요청 결과: $deleteSuccess");

      if (!deleteSuccess) {
        Fluttertoast.showToast(msg: "삭제 실패");
        return;
      }

      // 삭제 후 메뉴 재로드
      print("메뉴 재로드 시작");
      List<Map<String, dynamic>> latestFoodInfo = await _fetchMealsFromServer();
      print("메뉴 재로드 완료: $latestFoodInfo");

      // 최신 데이터 기반 기록 업데이트 요청
      bool updateSuccess = await _updateRecordDB(latestFoodInfo);
      print("기록 업데이트 결과: $updateSuccess");

      if (!updateSuccess) {
        Fluttertoast.showToast(msg: "기록 업데이트 실패");
        return;
      }

      // 성공 시 메인 화면으로 이동
      Fluttertoast.showToast(msg: "삭제 및 업데이트 완료");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyDiaryScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "오류 발생: $e");
      print("삭제 및 업데이트 중 오류 발생: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// 메뉴 정보를 서버에서 가져오기
  Future<List<Map<String, dynamic>>> _fetchMealsFromServer() async {
    User? user = await LoadUser.loadUser();
    if (user == null) {
      Fluttertoast.showToast(msg: "유저 ID를 찾을 수 없습니다.");
      return [];
    }

    try {
      final url = Uri.parse(API.loadUserMenu);
      var response = await http.post(
        url,
        body: {
          'id': user.user_id,
          'date': widget.selectedDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        print("메뉴 정보 불러오기 성공");
        final List<dynamic> data = jsonDecode(response.body);
        print("서버 응답 데이터: $data");

        // 파싱하여 최신 메뉴 정보 반환
        return data
            .map<Map<String, dynamic>>((info) => {
          'name': info['name'],
          'calories': info['calories'],
          'carbs': info['carbs'],
          'sugar': info['sugar'],
          'fat': info['fat'],
          'protein': info['protein'],
          'sodium': info['sodium'],
        })
            .toList();
      } else {
        print("서버 응답 실패: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("메뉴 정보 불러오기 오류: $e");
      return [];
    }
  }


// 기록 업데이트 요청
/*  Future<bool> _updateRecordDB(List<Map<String, dynamic>> updatedFoodInfo) async {
    try {
      User? user = await LoadUser.loadUser();
      print("유저 정보: $user");

      if (user == null) return false;

      // 기록 업데이트 계산
      double updatedCalories = 0.0;
      double updatedCarbs = 0.0;
      double updatedSugar = 0.0;
      double updatedFat = 0.0;
      double updatedProtein = 0.0;
      double updatedSodium = 0.0;

      print("기록 업데이트 시작: updatedFoodInfo = $updatedFoodInfo");

      for (var food in updatedFoodInfo) {
        updatedCalories += (food['calories'] as num).toDouble();
        updatedCarbs += (food['carbs'] as num).toDouble();
        updatedSugar += (food['sugar'] as num).toDouble();
        updatedFat += (food['fat'] as num).toDouble();
        updatedProtein += (food['protein'] as num).toDouble();
        updatedSodium += (food['sodium'] as num).toDouble();
      }

      // 계산 결과 디버깅
      print("계산된 영양소 합계:");
      print("칼로리: $updatedCalories, 탄수화물: $updatedCarbs, 당: $updatedSugar, 지방: $updatedFat, 단백질: $updatedProtein, 나트륨: $updatedSodium");

      final url = Uri.parse(API.updateUserDiary); // 기록 업데이트 API
      final response = await http.post(
        url,
        body: {
          'userid': user.user_id,
          'date': widget.selectedDate.toIso8601String(),
          'tcal': updatedCalories.toString(),
          'tcarbs': updatedCarbs.toString(),
          'tsugar': updatedSugar.toString(),
          'tfat': updatedFat.toString(),
          'tprotein': updatedProtein.toString(),
          'tsodium': updatedSodium.toString(),
        },
      );

      print("기록 업데이트 API 응답 상태: ${response.statusCode}");
      print("기록 업데이트 API 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("기록 업데이트 API 응답 파싱 결과: $jsonResponse");
        return jsonResponse['success'] == true;
      }
      return false;
    } catch (e) {
      print("기록 업데이트 중 오류 발생: $e");
      return false;
    }
  }*/
  Future<bool> _updateRecordDB(List<Map<String, dynamic>> updatedFoodInfo) async {
    try {
      User? user = await LoadUser.loadUser();
      print("유저 정보: $user");

      if (user == null) return false;

      // 기록 업데이트 계산
      double updatedCalories = 0.0;
      double updatedCarbs = 0.0;
      double updatedSugar = 0.0;
      double updatedFat = 0.0;
      double updatedProtein = 0.0;
      double updatedSodium = 0.0;

      print("기록 업데이트 시작: updatedFoodInfo = $updatedFoodInfo");

      for (var food in updatedFoodInfo) {
        updatedCalories += (food['calories'] as num).toDouble();
        updatedCarbs += (food['carbs'] as num).toDouble();
        updatedSugar += (food['sugar'] as num).toDouble();
        updatedFat += (food['fat'] as num).toDouble();
        updatedProtein += (food['protein'] as num).toDouble();
        updatedSodium += (food['sodium'] as num).toDouble();
      }

      // 계산된 값 전송
      final url = Uri.parse(API.updateUserDiary); // 기록 업데이트 API
      final response = await http.post(
        url,
        body: {
          'userid': user.user_id,
          'date': widget.selectedDate.toIso8601String(),
          'tcal': updatedCalories.toString(),
          'tcarbs': updatedCarbs.toString(),
          'tsugar': updatedSugar.toString(),
          'tfat': updatedFat.toString(),
          'tprotein': updatedProtein.toString(),
          'tsodium': updatedSodium.toString(),
        },
      );

      print("기록 업데이트 API 응답 상태: ${response.statusCode}");
      print("기록 업데이트 API 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("기록 업데이트 API 응답 파싱 결과: $jsonResponse");
        return jsonResponse['success'] == true;
      }
      return false;
    } catch (e) {
      print("기록 업데이트 중 오류 발생: $e");
      return false;
    }
  }


// 식단 삭제 서버 요청
  Future<bool> _deleteMealFromServer() async {
    User? user = await LoadUser.loadUser();

    try {
      final url = Uri.parse(API.deleteMenu); // 삭제 API 주소
      print("삭제 요청 URL: $url");

      final response = await http.post(
        url,
        body: {
          'userid': user?.user_id, // 유저 ID
          'date': widget.selectedDate.toIso8601String(), // 선택된 날짜
          'time': widget.title, // 삭제할 시간대
        },
      );

      print("삭제 요청 응답 상태: ${response.statusCode}");
      print("삭제 요청 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("삭제 요청 결과 파싱: $result");
        return result['result'] == 'true';
      } else {
        return false;
      }
    } catch (e) {
      print("삭제 요청 중 오류 발생: $e");
      return false;
    }
  }


  // 삭제 확인 다이얼로그 표시
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "삭제 확인",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF333333),
            ),
          ),
          content: Text(
            "정말 삭제하시겠습니까?",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "아니오",
                style: TextStyle(
                  color: Color(0xFF999999),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                _deleteMealAndGoToMain(); // 삭제 및 메인 이동 호출
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF759CE6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "예",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목과 닫기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF759CE6),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 음식 상세 정보
              Expanded(
                child: ListView.builder(
                  itemCount: widget.foodinfo.length,
                  itemBuilder: (context, index) {
                    final item = widget.foodinfo[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- ${item['name']} (${item['calories']} kcal)",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "탄수화물: ${item['carbs']}g, "
                                "당류: ${item['sugar']}g, "
                                "지방: ${item['fat']}g, "
                                "단백질: ${item['protein']}g, "
                                "나트륨: ${item['sodium']}mg",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 0.8,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // 총 칼로리 정보
              Text(
                "총 칼로리: ${widget.kcal} kcal",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // 삭제 버튼
              ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                ),
                child: Text(
                  "삭제",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
