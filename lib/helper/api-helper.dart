import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArticleReponse {
  final int userId;
  final int id;
  final String title;
  final String body;
  ArticleReponse({this.userId, this.id, this.title, this.body});
  factory ArticleReponse.fromJson(Map<String, dynamic> json) {
    return ArticleReponse(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

Future<ArticleReponse> getArticle(String id) async {
  String root = "https://jsonplaceholder.typicode.com/posts/";
  final response = await http.get(root + id);
  if (response.statusCode == 200) {
    return ArticleReponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}


Future<UserReponse> getUser(String url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return UserReponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class UserReponse {
  final int userId;
  final int id;
  final String title;
  final String body;
  UserReponse({this.userId, this.id, this.title, this.body});
  factory UserReponse.fromJson(Map<String, dynamic> json) {
    return UserReponse(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

