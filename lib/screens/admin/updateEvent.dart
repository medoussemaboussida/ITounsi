import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UpdateEventPage extends StatefulWidget {
  final String eventId;

  const UpdateEventPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _placeController;
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
    _titleController = TextEditingController();
    _dateController = TextEditingController();
    _placeController = TextEditingController();
    _descriptionController = TextEditingController();
    _photoController = TextEditingController();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    final uri = Uri.parse('http://192.168.1.34:5000/event/getEventById/${widget.eventId}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final event = data['event'];

      if (event is Map<String, dynamic>) {
        setState(() {
          _titleController.text = event['title'] ?? '';
          _dateController.text = event['event_date'] ?? '';
          _placeController.text = event['place'] ?? '';
          _descriptionController.text = event['event_description'] ?? '';
          _photoController.text = event['event_photo'] ?? '';
          // Assume category is not needed in this example
        });
      } else {
        print('Invalid data format: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load event details')),
        );
      }
    } else {
      print('Failed response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load event details')),
      );
    }
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final uri = Uri.parse('http://192.168.1.34:5000/event/updateEvent/${widget.eventId}');
      final request = http.MultipartRequest('PUT', uri)
        ..fields['title'] = _titleController.text
        ..fields['event_date'] = _dateController.text
        ..fields['place'] = _placeController.text
        ..fields['event_description'] = _descriptionController.text;

      if (_photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('event_photo', _photo!.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event updated successfully')),
        );
        Navigator.pop(context); // Retour à la page précédente après mise à jour
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event')),
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
    _titleController.dispose();
    _dateController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Text('Update Event'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                  fillColor: Colors.blueGrey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                  fillColor: Colors.blueGrey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.date_range),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: "Place",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                  fillColor: Colors.blueGrey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the place';
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
                  "Update Event",
                  style: TextStyle(color: Colors.blueGrey.shade100),
                ),
                color: Color(0xFF0088cc),
                borderRadius: BorderRadius.circular(40),
                onPressed: _updateEvent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String(); // Format the date as ISO 8601
      });
    }
  }
}
