import 'dart:convert'; // Pour json.decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pour http.get
import 'package:test_first/models/event.dart';
import 'package:test_first/screens/widget/event_widget.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> events = []; // Liste vide initialement

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Charger les événements lors de l'initialisation
  }

  Future<void> _loadEvents() async {
    try {
      final fetchedEvents = await fetchEvents(); // Appel de la méthode fetchEvents
      setState(() {
        events = fetchedEvents; // Initialiser la liste des événements
      });
    } catch (e) {
      // Gérer les erreurs, par exemple en affichant un message
      print('Failed to load events: $e');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final uri = Uri.parse('http://192.168.1.34:5000/event/getEvent');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data); // Déboguer la réponse JSON

      final List<dynamic> eventJson = data['eventList'] ?? [];
      return eventJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(50.0),
        ),
        Container(
          height: 250, // Ajuster la hauteur selon les besoins
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) => EventWidget(event: events[index]),
          ),
        ),
      ],
    );
  }
}
