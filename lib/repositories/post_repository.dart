import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts();
}

class HttpPostRepository implements PostRepository {
  HttpPostRepository({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  @override
  Future<List<Post>> fetchPosts() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch posts');
    }

    final json = jsonDecode(response.body) as List<dynamic>;

    return json
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
