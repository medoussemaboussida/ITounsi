import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/models/news.dart';
import 'package:test_first/screens/widget/admin_news_widget.dart';

Future<List<News>> fetchNews(String category) async {
  final uri = category == 'All'
      ? Uri.parse('http://192.168.1.27:5000/news/getNews')
      : Uri.parse('http://192.168.1.27:5000/news/getNewsByCategory/$category');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data); // Debug the JSON response

    final List<dynamic> newsJson = data['newsList'] ?? [];
    return newsJson.map((json) => News.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<News>> _newsFuture;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'IOT',
    'Cyber Security',
    'AI',
    'Blockchain',
    'Data management and analytics',
    'Software development',
  ];

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews(_selectedCategory);
  }

  void _refreshNews(String category) {
    setState(() {
      _selectedCategory = category;
      _newsFuture = fetchNews(_selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () => _refreshNews(category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueGrey.shade100 : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Color(0xFF0088cc) : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news found'));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return AdminNewsWidget(
                  news: newsList[index],
                  onDelete: () => _refreshNews(_selectedCategory),
                );
              },
            );
          }
        },
      ),
    );
  }
}
