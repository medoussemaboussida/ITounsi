import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEvent extends StatefulWidget {
  final VoidCallback? onEventAdded; // Ajout d'une fonction de rappel optionnelle

  const AddEvent({super.key, this.onEventAdded}); // Initialisation de la fonction de rappel

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _photo;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  Future<void> _pickPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = pickedFile;
    });
  }

  Future<void> _addEvent() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('http://192.168.1.27:5000/event/addEvent');
      final request = http.MultipartRequest('POST', uri)
        ..fields['title'] = _titleController.text
        ..fields['event_description'] = _descriptionController.text
        ..fields['place'] = _placeController.text
        ..fields['event_date'] = _dateController.text;

      if (_photo != null) {
        request.files.add(await http.MultipartFile.fromPath('event_photo', _photo!.path));
      }

      try {
        final response = await request.send();
        if (response.statusCode == 201) {
          final responseData = await response.stream.bytesToString();
          print('Event added successfully: $responseData');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event added successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Appel de la fonction de rafraîchissement si elle est définie
          widget.onEventAdded?.call(); 

          Navigator.pop(context); // Retour à la page précédente
        } else {
          print('Failed to add event: ${response.statusCode}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add event. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error adding event: $e');

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
        title: Text('Add Event'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 50),
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
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
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
                  "Add Event",
                  style: TextStyle(color: Colors.blueGrey.shade100),
                ),
                color: Color(0xFF0088cc),
                borderRadius: BorderRadius.circular(40),
                onPressed: _addEvent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
