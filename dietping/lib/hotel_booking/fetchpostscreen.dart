import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class FetchpostService {
  List<Map<String, dynamic>> posts = []; // 데이터를 저장할 리스트

  Future<void> fetchPosts() async {
    final url = Uri.parse(API.fetchpost); // fetchpost API 주소
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final fetchInfo = json.decode(response.body); // 응답 데이터를 JSON으로 파싱
        if (fetchInfo['result'] == 'true') {
          posts = List<Map<String, dynamic>>.from(fetchInfo['data'].map((post) => {
            'userid': post['userid']?.toString() ?? '',
            'communityID': post['communityID']?.toString() ?? '',
            'title': post['title']?.toString() ?? '',
            'picture': post['picture']?.toString() ?? '',
            'post': post['post']?.toString() ?? '',
            'calories': post['calories']?.toString() ?? '',
            'ingredient': post['ingredient']?.toString() ?? '',
            'date': post['date']?.toString() ?? '',
            'likes': post['likes']?.toString() ?? '',
            'views': post['views']?.toString() ?? '',
          })); 
        } else {
          throw Exception('Failed to fetch posts: ${fetchInfo['message']}');
        }
      } else {
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }
}
