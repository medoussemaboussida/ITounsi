import 'dart:convert'; // Pour json.decode
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Assurez-vous d'ajouter ce package dans pubspec.yaml
import 'package:readmore/readmore.dart';
import 'package:test_first/models/event.dart';
import 'package:http/http.dart' as http; // Pour http.get

class EventDetail extends StatefulWidget {
  const EventDetail({super.key, required this.eventId});
  final String eventId; // ID de l'événement

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late Future<Event> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = fetchEventById(widget.eventId); // Charger les détails de l'événement
  }

 Future<Event> fetchEventById(String eventId) async {
  final uri = Uri.parse('http://192.168.1.27:5000/event/getEventById/$eventId');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Print the received data for debugging
    print(data);

    // Assuming the JSON response has a structure like { "event": { ... } }
    final eventJson = data['event'];
    if (eventJson != null) {
      return Event.fromJson(eventJson);
    } else {
      throw Exception('Event data is null');
    }
  } else {
    throw Exception('Failed to load event');
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/appbarLogo.png', // Remplacez par le chemin de votre image
                height: 220, // Ajustez la hauteur selon vos besoins
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade100, // Couleur de l'arrière-plan de l'AppBar
        ),
        body: FutureBuilder<Event>(
          future: _eventFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final event = snapshot.data!;
              final imageUrl = 'http://192.168.1.27:5000/images/${event.event_photo}'; // URL de l'image
              return Container(
                margin: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        event.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20,), // Ajoutez cette ligne pour l'espacement
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.black),
                          SizedBox(width: 5), // Espacement entre l'icône et le texte
                          Text(
                            event.place,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.black),
                          SizedBox(width: 5), // Espacement entre l'icône et le texte
                          Text(
                            DateFormat('yyyy-MM-dd').format(event.event_date),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5), // Espacement entre la date et l'heure
                          Text(
                            DateFormat('| HH:mm').format(event.event_date),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ReadMoreText(
                        event.event_description,
                        trimMode: TrimMode.Line,
                        colorClickableText: Colors.blue.shade500,
                        style: TextStyle(color: Colors.black),
                        trimLines: 1,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: '. Show Less',
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
