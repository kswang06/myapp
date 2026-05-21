import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/repositories/post_repository.dart';

class PostsList extends StatefulWidget {
  const PostsList({
    super.key,
    required this.repository,
  });

  final PostRepository repository;

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = widget.repository.fetchPosts();
  }

  void retry() {
    setState(() {
      postsFuture = widget.repository.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index].title),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load posts'),
                ElevatedButton(onPressed: retry, child: const Text('Retry')),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
