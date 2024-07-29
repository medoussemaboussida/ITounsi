import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Assurez-vous d'ajouter ce package dans pubspec.yaml
import 'package:readmore/readmore.dart';
import 'package:test_first/models/event.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key, required this.event});
  final Event event;

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
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
        body: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.event.photo,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10,),
                Text(
                  widget.event.title,
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
                      widget.event.lieu,
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
                      DateFormat('yyyy-MM-dd').format(widget.event.date),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5), // Espacement entre la date et l'heure
                    Text(
                      DateFormat('| HH:mm').format(widget.event.date),
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
                  widget.event.description,
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
        ),
      ),
    );
  }
}
