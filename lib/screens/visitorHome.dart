import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_first/screens/visitor/events.dart';
import 'package:test_first/screens/visitor/news.dart';
import 'package:test_first/screens/visitor/profile.dart';

class Visitorhome extends StatefulWidget {
  const Visitorhome({super.key});

  @override
  State<Visitorhome> createState() => _MyWidgetState();
}
int _selectedIndex=0;
List<Widget> _screens=[NewsPage(),Events(),Profile()];

class _MyWidgetState extends State<Visitorhome> {
  void _onItemTapped(int index)
{
  setState(() {
    _selectedIndex=index;
  });
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
                backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar( title: Row(
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

          bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold, // Appliquer le texte en gras
             ),    
            items: [BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Color(0xFF0088cc),
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Events",
            backgroundColor: Color(0xFF0088cc),
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",   
           backgroundColor: Color(0xFF0088cc),

            )
            ],

          backgroundColor: Color(0xFF0088cc),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.blueGrey.shade100, 
          onTap: _onItemTapped,

          ),
        body:
         _screens[_selectedIndex],
    ),
    );
  }
}