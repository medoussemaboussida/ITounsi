import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:test_first/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/screens/admin/updateNews.dart';

Future<void> _deleteNews(BuildContext context, String id, VoidCallback onSuccess) async {
  final uri = Uri.parse('http://192.168.1.34:5000/news/deleteNews/$id');
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    print('News deleted successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('News deleted successfully')),
    );
    onSuccess(); // Appel de la fonction de rappel pour rafraîchir la page
  } else {
    print('Failed to delete news');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete news')),
    );
  }
}

class AdminNewsWidget extends StatelessWidget {
  const AdminNewsWidget({super.key, required this.news, required this.onDelete});

  final News news;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://192.168.1.34:5000/images/${news.news_photo}'; // URL de l'image

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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Date: ",
                  style: TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${news.news_date}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Description: ",
                  style: TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          ReadMoreText(
            news.description,
            trimMode: TrimMode.Line,
            colorClickableText: Color(0xFF0088cc),
            trimLines: 3,
            trimCollapsedText: 'Show more',
            trimExpandedText: '. Show Less',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateNewsPage(newsId: news.id),
                    ),
                  );
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _deleteNews(context, news.id, onDelete);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
