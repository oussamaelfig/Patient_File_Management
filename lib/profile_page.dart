import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String insuranceNumber;

  const ProfilePage({Key? key, required this.insuranceNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text('Nom: Alderson', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Prénom: Darlene', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Date de naissance: 08-05-1990',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
