import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:test_first/models/news.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key, required this.news});

  final News news;

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  bool isLiked = false;
  bool showCommentField = false;

  @override
  Widget build(BuildContext context) {
    // Construct the URL for the image
    final imageUrl = 'http://192.168.1.19:5000/images/${widget.news.news_photo}';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Failed to load image'));
            },
          ),
          SizedBox(height: 10),
          ReadMoreText(
            widget.news.description,
            trimMode: TrimMode.Line,
            colorClickableText: Color(0xFF0088cc),
            trimLines: 3,
            trimCollapsedText: 'Show more',
            trimExpandedText: '. Show Less',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                iconSize: 30,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Color(0xFF0088cc),
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.comment),
                color: Color(0xFF0088cc),
                onPressed: () {
                  setState(() {
                    showCommentField = !showCommentField;
                  });
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.share),
                color: Color(0xFF0088cc),
                onPressed: () {
                  // Logic for sharing
                },
              ),
            ],
          ),
          if (showCommentField)
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Write a comment...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
