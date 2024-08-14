import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_first/models/user.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key, required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
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
          /*CircleAvatar(
            backgroundColor: Color(0xFF0088cc),
            radius: 30,
            backgroundImage: user.photo.isNotEmpty 
                ? AssetImage(user.photo) 
                : null,
            child: user.photo.isEmpty 
                ? Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  )
                : null,
          ),*/
          SizedBox(height: 10),
          Text(
            "Username: ${user.username}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Date of Birth: ${user.dob.toLocal().toString().split(' ')[0]}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Email: ${user.email}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "etat: ${user.etat}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
