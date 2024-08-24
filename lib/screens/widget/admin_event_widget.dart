import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:test_first/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/screens/admin/updateEvent.dart';
import 'package:test_first/screens/admin/updateNews.dart';

Future<void> _deleteEvent(BuildContext context, String id, VoidCallback onSuccess) async {
  final uri = Uri.parse('http://192.168.1.27:5000/event/deleteEvent/$id');
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    print('Event deleted successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event deleted successfully')),
    );
    onSuccess(); // Appel de la fonction de rappel pour rafraîchir la page
  } else {
    print('Failed to delete event');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete event')),
    );
  }
}

class AdminEventWidget extends StatelessWidget {
  const AdminEventWidget({super.key, required this.event, required this.onDelete});

  final Event event;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://192.168.1.27:5000/images/${event.event_photo}'; // URL de l'image

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Failed to load image'));
            },
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Title: ",
                  style: TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${event.title}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Date: ",
                  style: TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${event.event_date}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Description: ",
                  style: TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          ReadMoreText(
            event.event_description,
            trimMode: TrimMode.Line,
            colorClickableText: Color(0xFF0088cc),
            trimLines: 3,
            trimCollapsedText: 'Show more',
            trimExpandedText: '. Show Less',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateEventPage(eventId: event.id),
                    ),
                  );
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _deleteEvent(context, event.id, onDelete);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
