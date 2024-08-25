import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_first/screens/admin/profile.dart';
import 'package:test_first/screens/admin/profileAdmin.dart';
import 'package:test_first/screens/signin.dart';
import 'package:test_first/screens/admin/addEvent.dart';
import 'package:test_first/screens/admin/addNews.dart';
import 'package:test_first/screens/admin/events.dart';
import 'package:test_first/screens/admin/news.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _MyWidgetState();
}

int _selectedIndex = 0;
List<Widget> _screens = [NewsPage(), Events(), Profile()];
List<String> _title = [
  "News management",
  "Events Management",
  "Profiles managements"
];

class _MyWidgetState extends State<Adminhome>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _username;
  String? _userPhoto;
  String? _email;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1), // Durée de l'animation en secondes
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _loadUserProfile(); // Charger les informations du profil lors de l'initialisation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.1.34:5000/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _username = data['username'];
            _email = data['email'];
            _userPhoto = data['user_photo'] != null
                ? 'http://192.168.1.34:5000/images/${data['user_photo']}'
                : null;
          });
        } else {
          print('Failed to load user profile: ${response.body}');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleDrawerOpen() {
    _animationController.forward();
  }

  void _handleDrawerClose() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          title: Text(
            _title[_selectedIndex],
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.blueGrey.shade100,
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          backgroundColor: Colors.blueGrey.shade100,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                          color: Color(0xFF0088cc), // Remplace l'image par une couleur bleue
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: _userPhoto != null
                          ? NetworkImage(_userPhoto!) as ImageProvider
                          : AssetImage("assets/dbz.png"),
                      radius: 40,
                    ),
                    SizedBox(height: 10), // Espacement entre l'image et les textes
                    Text(
                      _username ?? "Loading...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _email ?? "Loading... ", // Remplacez ceci par l'email récupéré si nécessaire
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.add),
                ),
                title: Text(
                  "News",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) => AddNews())));
                },
              ),
              ListTile(
                leading: RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.add),
                ),
                title: Text(
                  "Events",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) => AddEvent())));
                },
              ),
                  ListTile(
                leading: RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.update),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) => ProfileAdmin())));
                },
              ),
              ListTile(
                leading: RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.logout),
                ),
                title: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => Signin()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            _handleDrawerOpen();
          } else {
            _handleDrawerClose();
          }
        },
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "News",
              backgroundColor: Color(0xFF0088cc),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: "Events",
              backgroundColor: Color(0xFF0088cc),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Accounts",
              backgroundColor: Color(0xFF0088cc),
            ),
          ],
          backgroundColor: Color(0xFF0088cc),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.blueGrey.shade100,
          onTap: _onItemTapped,
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }
}
