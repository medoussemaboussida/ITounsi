import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_first/models/event.dart';
import 'package:test_first/screens/visitor/event_detail.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({
    super.key, required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://192.168.1.32:5000/images/${event.event_photo}'; // URL de l'image

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => EventDetail(eventId: event.id)), // Passez l'ID de l'événement
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Coins arrondis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4), // décalage de l'ombre
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              event.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
