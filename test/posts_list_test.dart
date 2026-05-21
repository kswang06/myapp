import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/repositories/post_repository.dart';
import 'package:myapp/widgets/posts_list.dart';

class MockPostRepository implements PostRepository {
  MockPostRepository(this.posts);

  final List<Post> posts;

  @override
  Future<List<Post>> fetchPosts() async {
    return posts;
  }
}

class LoadingPostRepository implements PostRepository {
  final completer = Completer<List<Post>>();

  @override
  Future<List<Post>> fetchPosts() {
    return completer.future;
  }
}

class ErrorPostRepository implements PostRepository {
  var calls = 0;

  @override
  Future<List<Post>> fetchPosts() async {
    calls++;

    if (calls == 1) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
      throw Exception('Failed');
    }

    return const [Post(id: 1, title: 'Recovered Post')];
  }
}

void main() {
  testWidgets('shows a CircularProgressIndicator while loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(child: PostsList(repository: LoadingPostRepository())),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders ListView with post titles on success', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PostsList(
            repository: MockPostRepository(const [
              Post(id: 1, title: 'Test Post'),
              Post(id: 2, title: 'Second Post'),
            ]),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Post'), findsOneWidget);
    expect(find.text('Second Post'), findsOneWidget);
  });

  testWidgets('renders an empty ListView when there are no posts', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PostsList(repository: MockPostRepository(const [])),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('shows an error message with a retry button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(child: PostsList(repository: ErrorPostRepository())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Failed to load posts'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry fetches posts again after an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(child: PostsList(repository: ErrorPostRepository())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Recovered Post'), findsOneWidget);
  });

  testWidgets('retry calls fetchPosts again', (tester) async {
    final repository = ErrorPostRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Material(child: PostsList(repository: repository)),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.calls, 1);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.text('Recovered Post'), findsOneWidget);
  });
}
