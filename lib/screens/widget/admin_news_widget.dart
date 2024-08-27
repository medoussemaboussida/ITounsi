import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_first/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/models/comment.dart'; // Assure-toi que le modèle Comment est importé
import 'package:test_first/screens/admin/updateNews.dart';

Future<void> _deleteNews(BuildContext context, String id, VoidCallback onSuccess) async {
  final uri = Uri.parse('http://192.168.1.27:5000/news/deleteNews/$id');
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

class AdminNewsWidget extends StatefulWidget {
  const AdminNewsWidget({super.key, required this.news, required this.onDelete});

  final News news;
  final VoidCallback onDelete;

  @override
  _AdminNewsWidgetState createState() => _AdminNewsWidgetState();
}

class _AdminNewsWidgetState extends State<AdminNewsWidget> {
  List<Comment> _comments = []; // Liste pour stocker les commentaires
  String? _userId;
  String? _newsId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadNewsId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.1.27:5000/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _userId = data['username'];
          });
        } else {
          print('Failed to load user profile: ${response.body}');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> _loadNewsId() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.27:5000/news/getNewsById/${widget.news.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _newsId = data['news']?['_id'];
        });
      } else {
        print('Failed to load news details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching news details: $e');
    }
  }

  Future<void> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.27:5000/comment/getAllComments/${widget.news.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['comments'];
        final List<Comment> loadedComments = [];

        for (var commentJson in data) {
          loadedComments.add(Comment.fromJson(commentJson)); // Utilise la méthode fromJson
        }

        setState(() {
          _comments = loadedComments;
        });
        _showCommentsDialog();
      } else {
        print('Failed to load comments: ${response.body}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      final uri = Uri.parse('http://192.168.1.27:5000/comment/deleteComment/$commentId');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment deleted successfully!')),
        );
        _fetchComments(); // Recharge les commentaires après la suppression
      } else {
        print('Failed to delete comment: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete comment.')),
        );
      }
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting comment.')),
      );
    }
  }

  void _showCommentsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _comments.length,
              itemBuilder: (BuildContext context, int index) {
                final comment = _comments[index];
                return ListTile(
                  title: Text(comment.username), // Affiche le nom d'utilisateur
                  subtitle: Text(
                    '${comment.commentText}\n${DateFormat('yyyy-MM-dd HH:mm').format(comment.commentDate.toLocal())}', // Affiche le texte du commentaire et la date
                  ),
                  trailing: (_userId != null && comment.username == _userId)
                      ? IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteComment(comment.id);
                            Navigator.of(context).pop();
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://192.168.1.27:5000/images/${widget.news.news_photo}'; // URL de l'image

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
                  text: "${widget.news.news_date}",
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
            widget.news.description,
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
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateNewsPage(newsId: widget.news.id),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _deleteNews(context, widget.news.id, widget.onDelete);
                },
              ),
              SizedBox(width: 10),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.comment),
                color: Colors.blue,
                onPressed: _fetchComments, // Ajoute le bouton pour afficher les commentaires
              ),
            ],
          ),
        ],
      ),
    );
  }
}
