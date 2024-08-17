import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UpdateNewsPage extends StatefulWidget {
  final String newsId;

  const UpdateNewsPage({Key? key, required this.newsId}) : super(key: key);

  @override
  State<UpdateNewsPage> createState() => _UpdateNewsPageState();
}

class _UpdateNewsPageState extends State<UpdateNewsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _photoController;
  String? _selectedCategory;
  XFile? _photo;
 final List<String> _categories = [
    'IOT', 
    'Cyber Security', 
    'AI', 
    'Blockchain', 
    'Data management and analytics', 
    'Software development'
  ];
  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _photoController = TextEditingController();
    _fetchNewsDetails();
  }

  Future<void> _fetchNewsDetails() async {
    final uri = Uri.parse('http://192.168.1.22:5000/news/getNewsById/${widget.newsId}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final news = data['news'];

      if (news is Map<String, dynamic>) {
        setState(() {
          _descriptionController.text = news['description'] ?? '';
          _photoController.text = news['news_photo'] ?? '';
          _selectedCategory = news['category'] ?? _categories.isNotEmpty ? _categories[0] : null;
        });
      } else {
        print('Invalid data format: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load news details')),
        );
      }
    } else {
      print('Failed response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news details')),
      );
    }
  }

  Future<void> _updateNews() async {
    if (_formKey.currentState?.validate() ?? false) {
      final uri = Uri.parse('http://192.168.1.22:5000/news/updateNews/${widget.newsId}');
      final request = http.MultipartRequest('PUT', uri)
        ..fields['description'] = _descriptionController.text
        ..fields['category'] = _selectedCategory ?? '';

      if (_photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('news_photo', _photo!.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('News updated successfully')),
        );
        Navigator.pop(context); // Retour à la page précédente après mise à jour
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update news')),
        );
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photo = pickedFile;
        _photoController.text = pickedFile.name;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Text('Update News'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                  fillColor: Colors.blueGrey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _photoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Photo",
                        labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                        fillColor: Colors.blueGrey.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.photo),
                      ),
                      validator: (value) {
                        if (_photo == null && (value == null || value.isEmpty)) {
                          return 'Please select a photo';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: _pickPhoto,
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                  fillColor: Colors.blueGrey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Update News",
                  style: TextStyle(color: Colors.blueGrey.shade100),
                ),
                color: Color(0xFF0088cc),
                borderRadius: BorderRadius.circular(40),
                onPressed: _updateNews,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
