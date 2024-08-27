import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNews extends StatefulWidget {
  final VoidCallback? onNewsAdded; // Ajout d'une fonction de rappel optionnelle

  const AddNews({super.key, this.onNewsAdded}); // Initialisation de la fonction de rappel

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  XFile? _photo;
  
  final List<String> _categories = [
    'IOT', 
    'Cyber Security', 
    'AI', 
    'Blockchain', 
    'Data management and analytics', 
    'Software development'
  ];

  String? _selectedCategory;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = pickedFile;
    });
  }

  Future<void> _addNews() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('http://192.168.1.27:5000/news/addNews');
      final request = http.MultipartRequest('POST', uri)
        ..fields['category'] = _selectedCategory ?? ''
        ..fields['description'] = _descriptionController.text;

      if (_photo != null) {
        request.files.add(await http.MultipartFile.fromPath('news_photo', _photo!.path));
      }

      try {
        final response = await request.send();
        if (response.statusCode == 201) {
          final responseData = await response.stream.bytesToString();
          print('News added successfully: $responseData');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('News added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Appel de la fonction de rafraîchissement si elle est définie
          widget.onNewsAdded?.call(); 

          Navigator.pop(context); // Retour à la page précédente
        } else {
          print('Failed to add news: ${response.statusCode}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add news. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error adding news: $e');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Text('Add News'),
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
                      controller: TextEditingController(text: _photo?.name),
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
                        if (_photo == null) {
                          return 'Please select a photo';
                        }
                        return null;
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: Icon(Icons.photo_library),
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
                  "Add News",
                  style: TextStyle(color: Colors.blueGrey.shade100),
                ),
                color: Color(0xFF0088cc),
                borderRadius: BorderRadius.circular(40),
                onPressed: _addNews,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
