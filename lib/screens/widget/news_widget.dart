import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_first/models/news.dart';
import 'package:test_first/models/comment.dart'; // Assure-toi que le modèle Comment est importé

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key, required this.news});

  final News news;

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  bool isLiked = false;
  bool showCommentField = false;
  final TextEditingController _commentController = TextEditingController();
  String? _userId;
  String? _newsId;
  List<Comment> _comments = []; // Liste pour stocker les commentaires

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
          Uri.parse('http://192.168.1.32:5000/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _userId = data['userId'];
          });
          print('User ID loaded: $_userId'); // Vérifie la valeur
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
        Uri.parse('http://192.168.1.32:5000/news/getNewsById/${widget.news.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _newsId = data['news']?['_id'];
        });
        print('News ID loaded: $_newsId'); // Vérifie la valeur
      } else {
        print('Failed to load news details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching news details: $e');
    }
  }

  Future<void> _addComment() async {
    final newsId = _newsId;
    final commentText = _commentController.text;

    print('Adding comment...');
    print('News ID: $newsId');
    print('Comment Text: $commentText');

    if (newsId == null || commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields and ensure you are logged in.')),
      );
      return;
    }

    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        print('Auth token is null');
        return;
      }

      final uri = Uri.parse('http://192.168.1.32:5000/comment/addComment/$newsId');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'commentText': commentText,
        }), // Envoie uniquement le texte du commentaire
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added successfully!')),
        );
        _fetchComments(); // Recharge les commentaires après l'ajout
      } else {
        print('Failed to add comment: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment.')),
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment.')),
      );
    }
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.32:5000/comment/getAllComments/${widget.news.id}'),
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
    final imageUrl = 'http://192.168.1.32:5000/images/${widget.news.news_photo}';

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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _addComment();
                    },
                  ),
                ],
              ),
            ),
          CupertinoButton(
            child: Text('View All Comments', style: TextStyle(color: Color(0xFF0088cc))),
            onPressed: _fetchComments,
          ),
        ],
      ),
    );
  }
}
