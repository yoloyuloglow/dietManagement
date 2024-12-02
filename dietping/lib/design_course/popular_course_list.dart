import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import 'category_food.dart';

class Category {
  final String contents;
  final String foodname;
  final String image;
  final String menucode;
  final String menuname;

  Category({
    required this.contents,
    required this.foodname,
    required this.image,
    required this.menucode,
    required this.menuname,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      contents: json['contents'] ?? '',
      foodname: json['foodname'] ?? '',
      image: json['image'] ?? '',
      menucode: json['menucode']?.toString() ?? '',
      menuname: json['menuname'] ?? '',
    );
  }
}

class PopularCourseList extends StatefulWidget {
  final String menucode;
  const PopularCourseList({Key? key, required this.menucode}) : super(key: key);

  @override
  _PopularCourseListState createState() => _PopularCourseListState();
}

class _PopularCourseListState extends State<PopularCourseList> {
  late Future<List<Category>> popularCourses;
  List<Category> courses = [];
  bool isLoading = false;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    popularCourses = fetchPopularCourses(); // 서버에서 첫 번째 페이지를 받아옴
    _scrollController.addListener(_scrollListener); // 스크롤 리스너 추가
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // 리스너 제거
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // 스크롤이 끝에 도달했을 때
      if (!isLoading) {
        setState(() {
          isLoading = true; // 데이터 로딩 중 표시
        });
        fetchMoreData();
      }
    }
  }

  // 첫 번째 페이지의 데이터를 받아오는 함수
  Future<List<Category>> fetchPopularCourses() async {
    try {
      final response = await http.post(Uri.parse(API.loadCategoryMenu), body: {
        'categoryid': widget.menucode,
        'page': currentPage.toString(), // 페이지 번호 전달
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> categorymenu = jsonResponse['categorymenu'] ?? [];
        return categorymenu.map((course) => Category.fromJson(course)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  // 더 많은 데이터를 받아오는 함수 (무한 스크롤)
  Future<void> fetchMoreData() async {
    currentPage++; // 페이지 번호 증가
    try {
      final response = await http.post(Uri.parse(API.loadCategoryMenu), body: {
        'categoryid': widget.menucode,
        'page': currentPage.toString(),
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> categorymenu = jsonResponse['categorymenu'] ?? [];
        List<Category> newCourses = categorymenu.map((course) => Category.fromJson(course)).toList();

        setState(() {
          courses.addAll(newCourses); // 기존 목록에 새로운 데이터를 추가
          isLoading = false; // 데이터 로딩 종료
        });
      } else {
        throw Exception('Failed to load more courses');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // 에러가 나도 로딩 종료
      });
      print('Failed to load more courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('특별한 식단')),
      body: FutureBuilder<List<Category>>(
        future: popularCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available.'));
          } else {
            // 최초 데이터
            if (courses.isEmpty) {
              courses = snapshot.data!;
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: courses.length + 1, // 로딩 아이템 추가
              itemBuilder: (context, index) {
                if (index == courses.length) {
                  // 데이터 로딩 중 표시
                  return isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                } else {
                  final category = courses[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              categoryfood(menuCode: category.menucode),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(category.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.menuname,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
