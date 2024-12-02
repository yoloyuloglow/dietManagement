import 'package:flutter/material.dart';
import 'fetchpostscreen.dart';
import 'fetchpostscreen.dart'; // FetchpostService import

class Fetchpost extends StatefulWidget {
  @override
  _FetchpostState createState() => _FetchpostState();
}

class _FetchpostState extends State<Fetchpost> {
  List<Map<String, dynamic>> posts = []; // 게시물 데이터를 저장할 리스트
  final FetchpostService fetchpostService = FetchpostService(); // FetchpostService 인스턴스 생성

  @override
  void initState() {
    super.initState();
    fetchPosts(); // 데이터 로드
  }

  Future<void> fetchPosts() async {
    await fetchpostService.fetchPosts(); // FetchpostService에서 데이터 로드
    setState(() {
      posts = fetchpostService.posts; // 데이터를 posts에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Posts'),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(post['title'] ?? 'Untitled'), // 제목 표시
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User ID: ${post['userid']}"),
                  Text("Post: ${post['post']}"),
                  Text("Calories: ${post['calories']}"),
                  Text("Ingredient: ${post['ingredient']}"),
                  Text("Date: ${post['date']}"),
                  Text("Likes: ${post['likes']}"),
                  Text("Views: ${post['views']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
