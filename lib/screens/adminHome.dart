import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_first/screens/admin/addEvent.dart';
import 'package:test_first/screens/admin/addNews.dart';
import 'package:test_first/screens/admin/events.dart';
import 'package:test_first/screens/admin/news.dart';
import 'package:test_first/screens/admin/profile.dart';
import 'package:test_first/screens/signin.dart';

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1), // Durée de l'animation en secondes
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          width: MediaQuery.of(context).size.width * 0.6,
          backgroundColor: Colors.blueGrey.shade100,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/drawer.png"), // Chemin de votre image
                    fit: BoxFit.cover,
                  ),
                  //color: Colors.blueGrey.shade100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/dbz.png"),
                      radius: 40,
                    ),
                    SizedBox(
                        height: 10), // Espacement entre l'image et les textes
                    Text(
                      "Med Oussema Boussida",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Itounsi@admin.tn",
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
              /* SizedBox(height: 320), // Espacement avant le logo
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Image.asset('assets/itounsiSecond.png'), // Remplacez par le chemin de votre image
                ),
              ),*/
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
