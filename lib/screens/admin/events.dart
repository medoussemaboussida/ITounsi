import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/models/event.dart';
import 'package:test_first/screens/widget/admin_event_widget.dart';

Future<List<Event>> fetchEvents() async {
  final uri = Uri.parse('http://192.168.1.44:5000/event/getEvent');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data); // Debug the JSON response

    final List<dynamic> eventJson = data['eventList'] ?? [];
    return eventJson.map((json) => Event.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            final eventsList = snapshot.data!;
            return ListView.builder(
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                return AdminEventWidget(
                  event: eventsList[index],
                  onDelete: _refreshEvents, // Passer la fonction de rappel ici
                );
              },
            );
          }
        },
      ),
    );
  }
}
