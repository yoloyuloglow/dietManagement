import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/api.dart';
import 'package:http/http.dart' as http;

class categoryfood extends StatefulWidget {
  final String menuCode;
  const categoryfood({Key? key, required this.menuCode}) : super(key: key);

  @override
  _CategoryFoodState createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<categoryfood> with TickerProviderStateMixin {
  List<dynamic> foodList = [];
  Map<String, dynamic> menuDetails = {};
  String selectedImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(Uri.parse(API.loadMenuFood), body: {
        'menuid': widget.menuCode,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['result'] == true) {
          //print(jsonResponse);

          final List<dynamic> menuDataList = jsonResponse['menu'];
          final List<dynamic> foodsData = jsonResponse['foods'];

          if (menuDataList.isEmpty || foodsData.isEmpty) {
            Fluttertoast.showToast(msg: '메뉴 데이터가 비어 있습니다.');
            return;
          }

          // menuDataList와 foodsData를 매칭
          final updatedFoodList = foodsData.map((food) {
            final matchedMenu = menuDataList.firstWhere(
                  (menu) => menu['foodcode'] == food['foodcoede'],
              orElse: () => {},
            );
            return {
              ...food,
              'menuDetails': matchedMenu,
            };
          }).toList();

          setState(() {
            foodList = updatedFoodList;
          });

          //print("Updated Food List: $foodList");
        } else {
          Fluttertoast.showToast(msg: '요청된 음식 정보 로딩에 실패했습니다');
        }
      } else {
        Fluttertoast.showToast(msg: '서버 오류로 음식 정보를 불러올 수 없습니다');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: foodList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('음식 상세 정보'),
          bottom: TabBar(
            isScrollable: true,
            tabs: foodList.map((food) {
              return Tab(text: food['foodname'] ?? 'Unknown');
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: foodList.map((food) {
            return FoodDetailView(
              foodName: food['foodname'] ?? 'Unknown',
              menuDetails: food['menuDetails'] ?? {},
              imageUrl: food['menuDetails']?['image'] ?? '',
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FoodDetailView extends StatelessWidget {
  final String foodName;
  final Map<String, dynamic> menuDetails;
  final String imageUrl;

  const FoodDetailView({
    Key? key,
    required this.foodName,
    required this.menuDetails,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 표시
          _buildImageSection(),
          const SizedBox(height: 16),

          // 기본 정보 (이름, 재료, 레시피, 메뉴 디테일)
          _buildSectionTitle('기본 정보'),
          _buildDetailRow('이름', foodName),
          _buildDetailRow('재료', menuDetails['matarialinfo'] ?? '정보 없음'),
          _buildDetailRow('레시피', menuDetails['recipeinfo'] ?? '정보 없음'),
          _buildDetailRow('설명', menuDetails['menudetail'] ?? '정보 없음'),

          const SizedBox(height: 16),

          // 영양소 정보
          _buildSectionTitle('영양소 정보'),
          ..._buildNutrientDetails(menuDetails),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    final fallbackImageUrl = menuDetails['image'] ?? ''; // 메뉴 이미지 경로

    return imageUrl.isNotEmpty
        ? Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 200,
      width: double.infinity,
    )
        : fallbackImageUrl.isNotEmpty
        ? Image.network(
      fallbackImageUrl,
      fit: BoxFit.cover,
      height: 200,
      width: double.infinity,
    )
        : Container(
      height: 200,
      color: Colors.grey,
      child: Center(child: Text('이미지 없음')),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNutrientDetails(Map<String, dynamic> details) {
    // 영문 키와 한국어 이름 매핑 테이블
    final Map<String, String> nutrientLabels = {
      'Natrium': '나트륨',
      'calcium': '칼슘',
      'iron': '철분',
      'fat': '지방',
      'protein': '단백질',
      'kcal': '칼로리',
      'choles': '콜레스테롤',
    };

    final nutrients = nutrientLabels.keys.toList();

    return nutrients.map((key) {
      final value = details[key] ?? '정보 없음';
      final label = nutrientLabels[key] ?? key; // 키를 한국어로 변환
      return _buildDetailRow(label, value); // 한국어 이름과 값 표시
    }).toList();
  }
}
