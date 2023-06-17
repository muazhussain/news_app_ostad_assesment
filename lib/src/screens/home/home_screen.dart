import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/src/data/news_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsPost> newsPost = [];
  int limit = 5;

  Future<void> fetchPosts() async {
    limit += 5;
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_start=0&_limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        newsPost.addAll(
            responseData.map((json) => NewsPost.fromJson(json)).toList());
      });
    }
  }

  @override
  void initState() {
    fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: newsPost.length + 1,
        itemBuilder: (context, index) {
          if (index == newsPost.length) {
            fetchPosts();
            return const SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListTile(
            leading: Text(newsPost[index].id.toString()),
            title: Text(newsPost[index].title.toString()),
            subtitle: Text(newsPost[index].body.toString()),
          );
        },
      ),
    );
  }
}
