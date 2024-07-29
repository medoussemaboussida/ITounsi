import 'package:flutter/material.dart';
import 'package:test_first/models/news.dart';
import 'package:test_first/screens/widget/news_widget.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  String selectedCategory = 'All';

  List<String> getCategories() {
    return ['All', ...NewsList.map((news) => news.category).toSet()];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: getCategories().map((category) {
                bool isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFF0088cc) : Colors.grey, // Replace 'primary'
                      foregroundColor: isSelected ? Colors.white : Colors.black, // Replace 'onPrimary'
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Text(category),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: NewsList.length,
              itemBuilder: (context, index) {
                if (selectedCategory == 'All' || NewsList[index].category == selectedCategory) {
                  return NewsWidget(news: NewsList[index]);
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
