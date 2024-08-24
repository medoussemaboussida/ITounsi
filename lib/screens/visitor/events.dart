import 'dart:convert'; // Pour json.decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pour http.get
import 'package:test_first/models/event.dart';
import 'package:test_first/screens/widget/event_widget.dart';
import 'package:intl/intl.dart'; // Pour DateFormat
import 'package:flutter/cupertino.dart'; // Pour DatePicker

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> events = []; // Liste vide initialement
  DateTime selectedDate = DateTime.now(); // Date sélectionnée

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

  Future<void> _filterEventsByDate(DateTime date) async {
    try {
      final uri = Uri.parse('http://192.168.1.27:5000/event/getEventsByDate/${DateFormat('yyyy-MM-dd').format(date)}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> eventJson = data['events'] ?? [];
        
        // Si aucun événement n'est trouvé, la liste reste vide
        setState(() {
          events = eventJson.map((json) => Event.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Failed to filter events: $e');
      // Si une erreur se produit, vider la liste des événements
      setState(() {
        events = [];
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await _filterEventsByDate(picked);
    }
  }

  Future<List<Event>> fetchEvents() async {
    final uri = Uri.parse('http://192.168.1.27:5000/event/getEvent');
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _loadEvents(); // Afficher tous les événements
                selectedDate = DateTime.now(); // Réinitialiser la date sélectionnée
              });
            },
            child: Text('All', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
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
          if (events.isEmpty)
            Center(
              child: Text('No events found for the selected date.', style: TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }
}
