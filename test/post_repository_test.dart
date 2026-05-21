import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myapp/repositories/post_repository.dart';

void main() {
  group('HttpPostRepository', () {
    test('fetchPosts returns posts from json response', () async {
      final client = MockClient((request) async {
        return http.Response('[{"id": 1, "title": "Test Post"}]', 200);
      });
      final repository = HttpPostRepository(client: client);

      final posts = await repository.fetchPosts();

      expect(posts.length, 1);
      expect(posts.first.id, 1);
      expect(posts.first.title, 'Test Post');
    });

    test('fetchPosts returns multiple posts from json response', () async {
      final client = MockClient((request) async {
        return http.Response('''
          [
            {"id": 1, "title": "First Post"},
            {"id": 2, "title": "Second Post"}
          ]
          ''', 200);
      });
      final repository = HttpPostRepository(client: client);

      final posts = await repository.fetchPosts();

      expect(posts.length, 2);
      expect(posts.first.title, 'First Post');
      expect(posts.last.title, 'Second Post');
    });

    test('fetchPosts sends request to the posts URL', () async {
      late Uri requestedUrl;
      final client = MockClient((request) async {
        requestedUrl = request.url;

        return http.Response('[]', 200);
      });
      final repository = HttpPostRepository(client: client);

      await repository.fetchPosts();

      expect(
        requestedUrl.toString(),
        'https://jsonplaceholder.typicode.com/posts',
      );
    });

    test('fetchPosts returns an empty list from empty json response', () async {
      final client = MockClient((request) async {
        return http.Response('[]', 200);
      });
      final repository = HttpPostRepository(client: client);

      final posts = await repository.fetchPosts();

      expect(posts, isEmpty);
    });

    test('fetchPosts throws when response is not successful', () async {
      final client = MockClient((request) async {
        return http.Response('Server error', 500);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<Exception>()));
    });

    test('fetchPosts throws when client request fails', () async {
      final client = MockClient((request) async {
        throw http.ClientException('Network failed', request.url);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<http.ClientException>()));
    });

    test('fetchPosts throws when json is invalid', () async {
      final client = MockClient((request) async {
        return http.Response('not json', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<FormatException>()));
    });

    test('fetchPosts throws when json response is not a list', () async {
      final client = MockClient((request) async {
        return http.Response('{"id": 1, "title": "Test Post"}', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<TypeError>()));
    });

    test('fetchPosts throws when post json is missing id', () async {
      final client = MockClient((request) async {
        return http.Response('[{"title": "Test Post"}]', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<TypeError>()));
    });

    test('fetchPosts throws when post json is missing title', () async {
      final client = MockClient((request) async {
        return http.Response('[{"id": 1}]', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<TypeError>()));
    });

    test('fetchPosts throws when post id is the wrong type', () async {
      final client = MockClient((request) async {
        return http.Response('[{"id": "1", "title": "Test Post"}]', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<TypeError>()));
    });

    test('fetchPosts throws when post title is the wrong type', () async {
      final client = MockClient((request) async {
        return http.Response('[{"id": 1, "title": 123}]', 200);
      });
      final repository = HttpPostRepository(client: client);

      expect(repository.fetchPosts(), throwsA(isA<TypeError>()));
    });
  });
}
