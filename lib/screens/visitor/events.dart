import 'package:flutter/material.dart';
import 'package:test_first/models/event.dart';
import 'package:test_first/screens/widget/event_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  DateTime _selectedDate = DateTime.now();
  List<Event> filteredEvents = EventList; // Par défaut, tous les événements sont affichés

  @override
  void initState() {
    super.initState();
    _filterEventsByDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events on ${_selectedDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, size: 30),
                onPressed: () {
                  _showCalendar(context);
                },
              ),
            ],
          ),
        ),
        Container(
          height: 250, // Ajuster la hauteur selon les besoins
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) => EventWidget(event: filteredEvents[index]),
          ),
        ),
      ],
    );
  }

  void _showCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2100),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _filterEventsByDate(selectedDay);
                });
                Navigator.pop(context); // Fermer la fenêtre modale
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 4.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              eventLoader: (day) {
                // Filtrer les événements pour une date donnée
                return EventList.where((event) {
                  return event.date.year == day.year &&
                         event.date.month == day.month &&
                         event.date.day == day.day;
                }).toList();
              },
            ),
          ),
        );
      },
    );
  }

  void _filterEventsByDate(DateTime date) {
    setState(() {
      filteredEvents = EventList.where((event) {
        return event.date.year == date.year &&
               event.date.month == date.month &&
               event.date.day == date.day;
      }).toList();
    });
  }
}
