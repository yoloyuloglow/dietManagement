import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_list_view.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/hotel_list_data.dart';
import 'fetchpostscreen.dart'; // FetchpostService import
import 'hotel_app_theme.dart';

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> posts = []; // 게시물 데이터를 저장할 리스트
  AnimationController? animationController; // 애니메이션 컨트롤러
  final FetchpostService fetchpostService = FetchpostService(); // FetchpostService 인스턴스 생성

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    fetchPosts(); // 데이터 로드
  }

  @override
  void dispose() {
    animationController?.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  // FetchpostService에서 데이터를 가져오는 함수
  Future<void> fetchPosts() async {
    await fetchpostService.fetchPosts(); // Fetchpos
    // tService의 fetchPosts 호출
    setState(() {
      posts = fetchpostService.posts; // 데이터를 posts에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Posts'),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator()) // 로딩 중
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return HotelListView(
            hotelData: HotelListData(
              imagePath: post['picture'] ?? '', // 이미지 경로
              titleTxt: post['title'] ?? 'No Title', // 제목
              subTxt: post['post'] ?? 'No Content', // 내용
              calories:
              int.tryParse(post['calories'] ?? '0') ?? 0, // 칼로리
            ),
            animationController: animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController!,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            callback: () {}, // 클릭 시 동작
          );
        },
      ),
    );
  }
}
